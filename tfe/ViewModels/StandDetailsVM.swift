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
    @Published var isUpdateButtonEnabled : Bool = true
    @Published var nameError : String? = nil
    @Published var descriptionError : String? = nil
    
    // data
    @Published var selectedStand : StandEntity
    var selectedStandAsHistory : StandHistoryEntity = StandHistoryEntity()
    @Published var histories : [StandHistoryEntity] = []
    {
        didSet {
            if (!self.histories.isEmpty) {
                self.selectedHistory = self.histories.last!
            }
        }
    }
    @Published var selectedHistory : StandHistoryEntity = StandHistoryEntity()
    // TODO: find a way to auto-bind coredata entity properties to textfields
    @Published var name : String = ""
    @Published var description : String = ""
    
    init(selectedStand: StandEntity) {
        self.selectedStand = selectedStand
        self.subscribeToCoreDataResources()
        self.name = selectedStand.name ?? ""
        self.description = selectedStand.standDescription ?? ""
        self.coreData.refreshLocalHistoriesForStand(id: selectedStand.id)
    }
    
    // MARK: DATA STORE functions
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localHistoriesEntitiesForSelectedStand
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { historyEntities in
                self.histories = historyEntities
                self.histories.sort { history1, history2 in
                    history1.capturedAt ?? "" < history2.capturedAt ?? ""
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: CORE DATA functions
    
    func updateStandDetails() {
        if !isValidName() {
            self.nameError = "cannot be empty"
            return
        }
        if !isValidDescription() {
            self.descriptionError = "cannot be empty"
            return
        }
        
        var standModel = StandModel(standEntity: self.selectedStand)
        standModel.name = self.name
        standModel.description = self.description
        
        api.updateTreeSubscription = self.api.updateStandDetails(stand: standModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Stand couldn't be updated\n\(error.localizedDescription)",
                        type: .error
                    )
                break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Stand has been updated",
                        type: .success
                    )
                break
                }
            }, receiveValue: { [weak self] standModel in
                self?.coreData.updateLocalStandDetails(standModel: standModel)
                self?.coreData.refreshLocalStands()
            })
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
