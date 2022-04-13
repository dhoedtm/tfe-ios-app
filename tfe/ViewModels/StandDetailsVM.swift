//
//  StandFormVM.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import Foundation
import SwiftUI
import Combine

final class StandDetailsVM: StateBindingViewModel<StandFormState> {
    
    // services
    private let api = ApiDataService.shared
    private let dataStore = InMemoryDataStore.shared
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // UI
    @Published var isFetchingHistories : Bool = false
    
    // data
    @Published var histories : [StandHistoryModel] = []
    {
        didSet {
            if (!self.histories.isEmpty) {
                self.selectedHistory = self.histories.last!
            }
        }
    }
    @Published var selectedHistory : StandHistoryModel = StandHistoryModel()
    
    override init(initialState: StandFormState) {
        super.init(initialState: initialState)
        subscribeToDataStore()
        getHistories()
        self.isFetchingHistories = true
    }
    
    // MARK: DATA STORE functions
    
    func subscribeToDataStore() {
        dataStore.$historiesForStands
            .sink { [weak self] (historiesForStands) in
                let idStand = Int(self?.state.id ?? "") ?? 0
                self?.histories = historiesForStands[idStand] ?? []
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getHistories() {
        let idStand = Int(self.state.id) ?? 0
        api.getHistoriesSubscription = api.getHistoriesForStand(idStand: idStand)
                .sink {  [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "Histories couldn't be retrieved\n(\(error.localizedDescription))",
                            type: .error)
                        break
                    case .finished:
                        break
                    }
                    self?.isFetchingHistories = false
                } receiveValue: { [weak self] (histories) in
                    self?.isFetchingHistories = false
                }
    }
    
    func updateStand() {
        if !isValidName() {
            state.nameError = "cannot be empty"
            return
        }
        if !isValidDescription() {
            state.descriptionError = "cannot be empty"
            return
        }
        
        let standModel = StandModel(standFormState: state)
        api.updateStandDetails(stand: standModel)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Stand couldn't be updated\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    self?.dataStore.allStands[standModel.id] = standModel
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: HANDLES FORM

    // MARK: - StateBindingViewModel Conformance
    
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<StandFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        return true
    }

    override func onStateChange(_ keyPath: PartialKeyPath<StandFormState>) {
        state.nameError = isValidName() ? nil : "name cannot be empty or >30 characters"
        // state.descriptionError = isValidDescription() ? nil : "description cannot be empty"
        state.isUpdateButtonEnabled = isValidForm()
    }

    // MARK: - Private Methods
    
    private func isValidDescription() -> Bool {
        return true // !state.description.isEmpty
    }
    private func isValidName() -> Bool {
        return !state.name.isEmpty && state.name.count < 30
    }
    
    private func isValidForm() -> Bool {
        return isValidName() && isValidDescription()
    }
}
