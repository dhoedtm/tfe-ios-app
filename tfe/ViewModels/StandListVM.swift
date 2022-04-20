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
    @Published var hasInternetConnection = Reachability.isConnectedToNetwork()
    @Published var isSyncingWithApi : Bool = false
    @Published var cancellableUploads : [CancellableItem] = []
    
    // data
    @Published var stands : [StandEntity] = []
    @Published var selectedStand : StandEntity?
    
    // MARK: init
    
    init() {
        subscribeToCoreDataResources()
        subscribeToApiUploadCancellables()
    }
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localStandEntities
            .sink { standEntities in
                self.stands = standEntities
            }
            .store(in: &cancellables)
    }
    
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
                    print(error)
                    break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Sync was successful",
                        type: .success)
                    break
                }
            } receiveValue: { [weak self] isOK in
                self?.coreData.save()
                self?.coreData.refreshLocalStands()
                self?.isSyncingWithApi = false
            }
    }
    
    func hardSyncWithApi() {
        self.isSyncingWithApi = true
        self.apiSyncCancellable = coreData.hardOneWayApiSync()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "An error occurred while fetching the data\n\(error)",
                        type: .error)
                    print(error)
                    break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Hard sync was successful",
                        type: .success)
                    break
                }
            } receiveValue: { [weak self] isOK in
                self?.coreData.save()
                self?.coreData.refreshLocalStands()
                self?.isSyncingWithApi = false
            }
    }
    
    func cancelSync() {
        self.apiSyncCancellable?.cancel()
        self.coreData.refreshLocalStands()
        self.isSyncingWithApi = false
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
                        self?.coreData.deleteLocalStandEntity(id: idStand)
                        self?.coreData.refreshLocalStands()
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
        let cancellableItemId = filePath.absoluteString
        let cancellableItemLabel = filePath.lastPathComponent
        
        let subscription = api.uploadPointCloud(fileURL: filePath)
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
