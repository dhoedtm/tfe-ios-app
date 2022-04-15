//
//  AppVM.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//

import Foundation
import Combine

class MainVM : ObservableObject {
    
    // services
    let notificationManager = NotificationManager.shared
    let coreData = CoreDataService.shared
    var apiSyncCancellable : AnyCancellable?
    
    // ui
    @Published var isSyncingWithApi = false
    @Published var hasInternetConnection = Reachability.isConnectedToNetwork()
    @Published var wantsToSync = true
    
    init() {
        if (!self.hasInternetConnection) {
            self.notificationManager.notification = Notification(
                message: "Cannot access the internet",
                type: .info
            )
        }
    }
    
    func sync() {
        self.isSyncingWithApi = true
        apiSyncCancellable = coreData.oneWayApiSync()
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
                self?.isSyncingWithApi = false
                self?.wantsToSync = false
            }
    }
    
    func cancelSync() {
        self.apiSyncCancellable?.cancel()
        self.isSyncingWithApi = false
    }
}
