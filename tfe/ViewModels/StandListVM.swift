//
//  StandListVM.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class StandListVM : ObservableObject {
    
    // services
    private let api = ApiDataService.shared
    private let coreData = CoreDataService.shared
    private let notificationManager = NotificationManager.shared
    private var apiSyncCancellable : AnyCancellable?
    private var cancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    // UI
    @Published var isSyncingWithApi : Bool = false
    @Published var cancellableUploads : [CancellableItem] = []
    
    // data
    @Published var stands : [StandEntity] = []
    @Published var selectedStand : StandModel?
    
    // MARK: init
    
    init() {
        getStands()
        subscribeToApiUploadCancellables()
    }
    
    // MARK: UI functions
    
    // MARK: API functions
    
    func subscribeToApiUploadCancellables() {
        self.api.$uploadStandSubscriptions
            .sink { cancellableUploads in
                self.cancellableUploads = Array(cancellableUploads)
            }
            .store(in: &cancellables)
    }
        
    func syncWithApi() {
        self.isSyncingWithApi = true
        self.apiSyncCancellable = coreData.oneWayApiSync()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "An error occurred while fetching the data\n\(error)",
                        type: .error)
                    break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Sync was successful",
                        type: .success)
                    break
                }
            } receiveValue: { [weak self] isOK in
                print("[coreData.oneWayApiSync] sync status : \(isOK ? "OK" : "KO")")
                self?.coreData.save()
                self?.getStands()
                self?.isSyncingWithApi = false
            }
    }
    
    func cancelSync() {
        self.apiSyncCancellable?.cancel()
        self.isSyncingWithApi = false
    }
    
    func getStands() {
        self.coreData.fetchLocalStands()
        self.stands = self.coreData.localStandEntities
    }
    
    func deleteStand(offsets: IndexSet) {
        if let offset = offsets.first {
            let idStand = self.stands[offset].id
            api.deleteStandSubscription = api.deleteStand(idStand: Int(idStand))
                .sink { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "Stand couldn't be deleted\n(\(error.localizedDescription)",
                            type: .error)
                        break
                    case .finished:
                        self?.stands.remove(atOffsets: offsets)
                        self?.coreData.deleteStandById(id: Int(idStand))
                        break
                    }
                } receiveValue: { _ in }
        }
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
        let subscription = api.uploadPointCloud(fileURL: filePath)
            .sink(
                receiveCompletion: { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "stands couldn't be retrieved\n(\(error.localizedDescription))",
                            type: .error)
                        break
                    case .finished:
                        break
                    }
                },
                receiveValue: { uploadResponse in
                    switch uploadResponse {
                    case let .progress(percentage):
                        print("progress : \(percentage)")
                    case let .response(data):
                        print("response OK [\(data?.count ?? 0)B]")
                    }
                })
        
        self.api.uploadStandSubscriptions.insert(
            CancellableItem(
                id: filePath.absoluteString,
                cancellable: subscription,
                label: filePath.lastPathComponent
            )
        )
    }
    
    func cancelUpload(item: CancellableItem) {
        self.api.cancelUploadStandSubscriptions(id: item.id)
    }
}
