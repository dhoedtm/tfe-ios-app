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
    private var cancellables = Set<AnyCancellable>()
    
    // UI
    @Published var isFetchingStands : Bool = false
    @Published var isSyncingWithApi : Bool = false
    @Published var cancellableUploads : [CancellableItem] = []
    
    // data
    @Published var stands : [StandModel] = []
    @Published var selectedStand : StandModel?
    
    // MARK: init
    
    init() {
    }
    
    // MARK: UI functions
    
    func reloadStandList() {
//        withAnimation {
//            self.isFetchingStands = true
//            api.getStandsSubscription?.cancel()
//            getStands()
//        }
    }
    
    // MARK: API functions
        
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
                self?.isSyncingWithApi = true
            }
    }
    
    func cancelSync() {
        self.apiSyncCancellable?.cancel()
        self.isSyncingWithApi = false
    }
    
    func getStands() {
//        api.getStandsSubscription = api.getStands()
//            .eraseToAnyPublisher()
//            .sink(
//                receiveCompletion: { [weak self] (completion) in
//                    switch completion {
//                    case .failure(let error):
//                        self?.notificationManager.notification = Notification(
//                            message: "stands couldn't be retrieved\n(\(error.localizedDescription))",
//                            type: .error)
//                        break
//                    case .finished:
//                        break
//                    }
//                    self?.isFetchingStands = false
//                },
//                receiveValue: { [weak self] (stands) in
//                })
    }
    
    func cancelStandDownload() {
        api.getStandsSubscription?.cancel()
        isFetchingStands = false
    }
    
    func deleteStand(offsets: IndexSet) {
        if let offset = offsets.first {
            let idStand = self.stands[offset].id
            api.deleteStandSubscription = api.deleteStand(idStand: idStand)
                .sink { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "Stand couldn't be deleted\n(\(error.localizedDescription)",
                            type: .error)
                        break
                    case .finished:
                        self?.stands.remove(atOffsets: offsets)
                        break
                    }
                } receiveValue: { _ in }
        }
    }
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            let subscription = api.uploadPointCloud(fileURL: path)
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
                        self?.isFetchingStands = false
                    },
                    receiveValue: { [weak self] (uploadResponse) in
                        switch uploadResponse {
                        case let .progress(percentage):
                            print("progress : \(percentage)")
                        case let .response(data):
                            print("response OK [\(data?.count ?? 0)B]")
                        }
                    })
                .store(in: &cancellables)
            // TODO: make cancellable button list
            
        }
    }
}
