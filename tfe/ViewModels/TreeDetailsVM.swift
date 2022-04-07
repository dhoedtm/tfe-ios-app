//
//  TreeCapturesVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//

import Foundation

final class TreeDetailsVM : StateBindingViewModel<TreeFormState> {
    
    let api : ApiDataService = ApiDataService()
    
    // MARK: - Public Methods
    func updateTree() {
//        if !isValidDescription() {
//            state.descriptionError = "cannot be empty"
//            return
//        }
        
        let treeModel = TreeModel(treeFormState: self.state)
        print("[updateTree] \(treeModel)")
        api.updateTreeDetails(tree: treeModel)
    }

    // MARK: - StateBindingViewModel Conformance
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<TreeFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        return true
    }

    override func onStateChange(_ keyPath: PartialKeyPath<TreeFormState>) {
//        state.descriptionError = isValidDescription() ? nil : "description cannot be empty"
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
