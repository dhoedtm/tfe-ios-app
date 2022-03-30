//
//  StandFormVM.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import Foundation
import SwiftUI
import Combine

final class StandFormVM: StateBindingViewModel<StandFormState> {
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    
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
        state.nameError = isValidDescription() ? nil : "description cannot be empty"
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
