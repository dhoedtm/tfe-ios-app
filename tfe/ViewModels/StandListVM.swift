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
    @Published var cancellableUploads : [CancellableItem] = []
    
    // data
    @Published var stands : [StandEntity] = []
    @Published var selectedStand : StandEntity?
    
    // MARK: init
    
    init() {
        print("StandListVM - INIT")
        subscribeToCoreDataResources()
        subscribeToApiUploadCancellables()
    }
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localStandEntities
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
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
    
    func syncWithApi(isHardSync: Bool) {
        print("ATTEMPT")
        if (self.coreData.isSyncingWithApi) {
            print("NON")
            self.notificationManager.notification = Notification(
                message: "Already syncing with API",
                type: .warning)
        } else {
            print("OUI")
            if (isHardSync) {
                sinkForApiSync(publisher: coreData.hardOneWayApiSync())
            } else {
                sinkForApiSync(publisher: coreData.oneWayApiSync())
            }
        }
    }
    
    func sinkForApiSync(publisher: AnyPublisher<Bool, Error>) {
        print("WENT THROUGH")
        self.apiSyncCancellable = publisher
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
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
                    self?.coreData.save()
                    self?.coreData.refreshLocalStands()
                    self?.coreData.isSyncingWithApi = false
                    break
                }
            } receiveValue: { _ in }
    }
    
    //    func cancelSync() {
    //        self.apiSyncCancellable?.cancel()
    //        self.coreData.refreshLocalStands()
    //        self.isSyncingWithApi = false
    //    }
    
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
        self.api.createNewStand(fileURL: filePath)
            .print("VM :")
            .sink { completion in
                switch completion {
                case .failure(_):
                break
                case .finished:
                break
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    func cancelUpload(fileURL: String) {
        self.api.cancelUploadStandSubscriptions(fileURL: fileURL)
    }
}
