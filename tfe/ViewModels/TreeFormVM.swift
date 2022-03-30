//
//  TreeFormVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation

final class TreeFormVM: StateBindingViewModel<TreeFormState> {
    // MARK: - Public Methods
    func updateTree() {
        if !isValidDescription() {
            state.descriptionError = "cannot be empty"
            return
        }
        
        // api call
    }

    // MARK: - StateBindingViewModel Conformance
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<TreeFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        switch (keyPath, newValue) {
        case let (\TreeFormState.description, newValue as String):
            state.descriptionError = nil
            return newValue.count < 50
        default:
            return true
        }
    }

    override func onStateChange(_ keyPath: PartialKeyPath<TreeFormState>) {
        state.isUpdateButtonEnabled = isValidForm()
    }

    // MARK: - Private Methods
    
    private func isValidDescription() -> Bool {
        return !state.description.isEmpty
    }
    
    private func isValidForm() -> Bool {
        return isValidDescription()
    }
}
