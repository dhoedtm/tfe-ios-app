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
        
    // UI
    @Published var isFetchingTrees : Bool = false
    
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
                print("NEW TREES : \(treeEntities.count)")
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
                        self?.coreData.refreshLocalTreesForStand(id: self?.selectedStand.id ?? 0)
                        self?.notificationManager.notification = Notification(
                            message: "Trees inside this stand are now up to date",
                            type: .success)
                        self?.coreData.save()
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
            } receiveValue: { [weak self] _ in
                self?.coreData.deleteLocalTree(id: idTree)
                self?.coreData.save()
            }
            .store(in: &cancellables)
    }
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            if (self.api.getCancellableUpload(id: path.absoluteString) != nil) {
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
        let cancellableItemId = filePath.absoluteString
        let cancellableItemLabel = filePath.lastPathComponent
        
        let subscription = api.uploadPointCloud(idStand: Int(self.selectedStand.id), fileURL: filePath)
            .receive(on: DispatchQueue.main)
            .print("VM upload :")
            .sink(
                receiveCompletion: { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "stand couldn't be uploaded\n(\(error.localizedDescription))",
                            type: .error)
                        self?.api.cancelUploadStandSubscriptions(cancellableItemId: cancellableItemId)
                        break
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] uploadResponse in
                    // progress not working for an upload task with Data
                    // works fine for an upload task with a file
                    switch uploadResponse {
                    case let .progress(percentage):
                        print("progress : \(percentage)")
                    case let .response(data):
                        self?.notificationManager.notification = Notification(
                            message: "stand \(cancellableItemLabel) uploaded)",
                            type: .success)
                        self?.api.cancelUploadStandSubscriptions(cancellableItemId: cancellableItemId)
                        // print("response OK [\(data)B]")
                    }
                })
        
        self.api.uploadStandSubscriptions.insert(
            CancellableItem(
                id: cancellableItemId,
                cancellable: subscription,
                label: cancellableItemLabel
            )
        )
    }
    
    func cancelUpload(item: CancellableItem) {
        self.api.cancelUploadStandSubscriptions(cancellableItemId: item.id)
    }
}

