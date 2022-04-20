//
//  StandFormVM.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import Foundation
import SwiftUI
import Combine

final class StandDetailsVM: ObservableObject {
    
    // services
    private let api = ApiDataService.shared
    private let coreData = CoreDataService.shared
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // UI
    @Published var isFetchingHistories : Bool = false
    @Published var isUpdateButtonEnabled : Bool = true
    @Published var nameError : String? = nil
    @Published var descriptionError : String? = nil
    
    // data
    @Published var histories : [StandHistoryEntity] = []
    @Published var selectedHistory : StandHistoryEntity? = nil
    // TODO: find a way to auto-bind coredata entity properties to textfields
    @Published var name : String = ""
    @Published var description : String = ""
    
    init(selectedStand: StandEntity) {
        self.subscribeToCoreDataResources()
        self.coreData.refreshLocalHistoriesForStand(id: selectedStand.id)
        self.isFetchingHistories = true
    }
    
    // MARK: DATA STORE functions
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localHistoriesEntitiesForSelectedStand
            .sink { historyEntities in
                self.histories = historyEntities
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getHistories() {
        print("[StandDetailsVM][getHistories] TODO")
    }
    
    func updateStandDetails() {
        if !isValidName() {
            self.nameError = "cannot be empty"
            return
        }
        if !isValidDescription() {
            self.descriptionError = "cannot be empty"
            return
        }
        
        print("[StandDetailsVM][updateStandDetails] TODO")
    }
    
    // MARK: HANDLES FORM
    
    private func isValidDescription() -> Bool {
        return true // !self.description.isEmpty
    }
    private func isValidName() -> Bool {
        return !self.name.isEmpty && self.name.count < 30
    }
    
    private func isValidForm() -> Bool {
        return isValidName() && isValidDescription()
    }
}
