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
        // state.description ... check
    }

    // MARK: - StateBindingViewModel Conformance
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<TreeFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
//        switch (keyPath, newValue) {
//        case let (\TreeFormState.description, newValue as String):
//            state.descriptionError = nil
//            return newValue.count <= 12
//        default:
//            return true
//        }
        return true
    }

    override func onStateChange(_ keyPath: PartialKeyPath<TreeFormState>) {
//        state.isUpdateButtonEnabled = isValidForm()
    }

    // MARK: - Private Methods
    private func isValidForm() -> Bool {
        return !state.description.isEmpty
    }
}
