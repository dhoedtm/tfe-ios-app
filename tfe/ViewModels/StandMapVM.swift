//
//  StandMapVM.swift
//  TFE
//
//  Created by user on 01/03/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class StandMapVM : ObservableObject {
    
    // services
    private let api = ApiDataService.shared
    private let coreData = CoreDataService.shared
    private let notificationManager = NotificationManager.shared
    
    private var cancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    private var updateTreesCancellable : AnyCancellable?
    private var uploadPointcloudCancellable : AnyCancellable?
    
    // UI
    @Published var isFetchingTrees : Bool = false
    @Published var isUploadingPointcloud : Bool = false
    
    // data
    @Published var selectedStand : StandEntity
    @Published var trees : [TreeEntity] = [] {
        didSet {
            self.treeSelection()
        }
    }
    @Published var selectedTree : TreeEntity? {
        didSet {
            if let tree = self.selectedTree {
                updateMapRegion(tree: tree)
            }
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedTree"
    @Published var selectedTreeRegion : MKCoordinateRegion = MKCoordinateRegion()
    
    // MARK: init
    
    init(selectedStand: StandEntity) {
        self.selectedStand = selectedStand
        self.coreData.refreshLocalTreesForStand(id: selectedStand.id)
        self.subscribeToCoreDataResources()
    }
    
    // MARK: UI functions
    
    /// Handles the selection when:
    /// - the map is loaded for the first time
    /// - the trees are refreshed and references have become stale
    /// - the selected tree is deleted
    func treeSelection() {
        if (self.trees.isEmpty) {
            self.selectedTree = nil
            return
        }
        // update stale reference to a selected tree that no longer exists
        let treeToSelect = self.trees.first(where: { entity in
            entity.id == (self.selectedTree?.id ?? 0)
        })
        // if no selectable tree was found, select the first tree in the list
        self.selectedTree = (treeToSelect != nil ? treeToSelect : self.trees.first ?? nil)
    }
    
    func getLocationFromCoordinates(tree: TreeEntity) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    private func getRegionFromCoordinates(tree: TreeEntity) -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // where to focus the map
            span: self.selectedTreeRegion.span // zoom amount
        )
    }
    
    func updateMapRegion(tree: TreeEntity) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
    
    // MARK: CORE DATA functions
    
    func subscribeToCoreDataResources() {
        self.coreData.$localTreeEntitiesForSelectedStand
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { [weak self] (treeEntities) in
                let sortedTrees = treeEntities.sorted(by: { tree1, tree2 in
                    tree1.id < tree2.id
                })
                self?.trees = sortedTrees
            }
            .store(in: &cancellables)
    }
    
    func updateTrees() {
        self.isFetchingTrees = true
        self.updateTreesCancellable = self.coreData.fetchRemoteTreesForStand(id: self.selectedStand.id)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Trees couldn't be updated\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Trees inside this stand are now up to date",
                        type: .success)
                    self?.coreData.save()
                    self?.coreData.refreshLocalTreesForStand(id: self?.selectedStand.id ?? 0)
                    self?.isFetchingTrees = false
                    break
                }
            } receiveValue: { _ in }
    }
    
    func cancelTreesDownload() {
        self.isFetchingTrees = false
        self.updateTreesCancellable?.cancel()
    }
    
    func deleteTree(idTree: Int32) {
        api.deleteTree(idTree: idTree)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Tree couldn't be deleted\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    break
                }
            } receiveValue: { _ in
                self.coreData.deleteLocalTree(id: idTree)
                self.coreData.refreshLocalTreesForStand(id: self.selectedStand.id)
                self.coreData.fetchRemoteStandAndHistories(standEntity: self.selectedStand)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { _ in
                            self.coreData.save()
                            self.coreData.refreshLocalHistoriesForStand(id: self.selectedStand.id)
                        }
                    )
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            if (self.api.uploadStandSubscriptionExists(fileURL: path.absoluteString)) {
                notificationManager.notification = Notification(
                    message: "already uploading file \(path.lastPathComponent)",
                    type: .warning
                )
            } else {
                self.uploadPointCloud(filePath: path)
            }
        }
    }
    
    func uploadPointCloud(filePath: URL) {
        self.isUploadingPointcloud = true
        self.uploadPointcloudCancellable = self.api.updateStandWithPointcloud(
            idStand: Int(self.selectedStand.id),
            fileURL: filePath
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                self.notificationManager.notification = Notification(
                    message: "Couldn't upload file : \(filePath.lastPathComponent)\n\(error)",
                    type: .error
                )
                self.isUploadingPointcloud = false
                break
            case .finished:
                break
            }
        } receiveValue: { uploadResponse in
            self.handleUploadResponse(filePath: filePath, uploadResponse: uploadResponse)
        }
    }
    
    func handleUploadResponse(filePath: URL, uploadResponse: UploadResponse) {
            switch uploadResponse{
            case .progress(percentage: let percentage):
                if (percentage > 0 && percentage < 95) {
                    self.api.updateStandSubscriptionProgress(fileURL: filePath.absoluteString, progress: percentage)
                    break
                }
                if (percentage >= 95) {
                    self.api.updateStandSubscriptionAction(fileURL: filePath.absoluteString, action: .waitingForServer)
                    self.notificationManager.notification = Notification(
                        message: "Fully uploaded file : \(filePath.lastPathComponent)\nWaiting for server analysis",
                        type: .info
                    )
                }
            case .response(data: let data):
                if let data = data {
                    self.updateStandInCoreData(filePath:filePath, standData: data)
                }
            }
    }
    
    func updateStandInCoreData(filePath: URL, standData: Data) {
        do {
            let standModel = try JSONDecoder().decode(StandModel.self, from: standData)
            self.coreData.updateStand(stand: standModel)
                .sink { completion in
                    switch completion {
                    case .failure(_):
                        self.notificationManager.notification = Notification(
                            message: "Updated stand couldn't be saved locally",
                            type: .success
                        )
                    case .finished:
                        break
                    }
                } receiveValue: { isOk in
                    self.notificationManager.notification = Notification(
                        message: "Updated stand is now available offline",
                        type: .success
                    )
                    self.coreData.refreshLocalStands()
                    self.coreData.refreshLocalHistoriesForStand(id: self.selectedStand.id)
                    self.coreData.refreshLocalTreesForStand(id: self.selectedStand.id)
                }
                .store(in: &self.cancellables)
        } catch(let error) {
            self.notificationManager.notification = Notification(
                message: "Internal error\n\(error)",
                type: .success
            )
        }
        self.notificationManager.notification = Notification(
            message: "Fully analyzed file : \(filePath.lastPathComponent)",
            type: .success
        )
        self.isUploadingPointcloud = false
    }
    
    func cancelUpload() {
        self.uploadPointcloudCancellable?.cancel()
        self.isUploadingPointcloud = false
    }
}

