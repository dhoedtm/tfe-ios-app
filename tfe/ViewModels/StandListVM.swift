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
import Moya

class StandListVM : ObservableObject {
    
    // services
    private let api = ApiDataService.shared
    private let dataStore = InMemoryDataStore.shared
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // UI
    @Published var isFetchingStands : Bool = false
    @Published var cancellableUploads : [CancellableItem] = []
    
    // data
    @Published var stands : [StandModel] = []
    @Published var selectedStand : StandModel?
    
    // MARK: init
    
    init() {
        subscribeToDataStore()
        getStands()
        self.isFetchingStands = true
    }
    
    // MARK: UI functions
    
    func reloadStandList() {
        withAnimation {
            self.isFetchingStands = true
            api.getStandsSubscription?.cancel()
            getStands()
        }
    }
    
    // MARK: DATA STORE functions
    
    func subscribeToDataStore() {
        dataStore.$allStands
            .sink { stands in
                self.stands = stands
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getStands() {
        api.getStandsSubscription = api.getStands()
            .eraseToAnyPublisher()
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
                receiveValue: { [weak self] (stands) in
                    self?.dataStore.allStands = stands
                })
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
