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
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isFetchingHistories : Bool = false
    
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
        
        self.isFetchingHistories = true
        addSubscribers()
        api.getHistoriesForStand(idStand: Int(state.id) ?? 0)
    }
    
    func addSubscribers() {
        api.$historiesForStands
            .sink { [weak self] (stands) in
                let id = (self?.state.id)!
                self?.histories = stands[Int(id) ?? 0] ?? []
                self?.isFetchingHistories = false
            }
            .store(in: &cancellables)
    }
    
    // MARK: HANDLES FORM
    
    // MARK: - Public Methods
    
    func updateStand() {
        if !isValidName() {
            state.nameError = "cannot be empty"
            return
        }
        if !isValidDescription() {
            state.descriptionError = "cannot be empty"
            return
        }
        
        api.updateStandDetails(stand: StandModel(standFormState: state))
    }

    // MARK: - StateBindingViewModel Conformance
    
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<StandFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        return true
    }

    override func onStateChange(_ keyPath: PartialKeyPath<StandFormState>) {
        state.nameError = isValidName() ? nil : "name cannot be empty or >30 characters"
        state.descriptionError = isValidDescription() ? nil : "description cannot be empty"
        state.isUpdateButtonEnabled = isValidForm()
    }

    // MARK: - Private Methods
    
    private func isValidDescription() -> Bool {
        return !state.description.isEmpty
    }
    private func isValidName() -> Bool {
        return !state.name.isEmpty && state.name.count < 30
    }
    
    private func isValidForm() -> Bool {
        return isValidName() && isValidDescription()
    }
}
