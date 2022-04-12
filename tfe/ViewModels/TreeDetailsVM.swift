//
//  TreeCapturesVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//

import Foundation

final class TreeDetailsVM : StateBindingViewModel<TreeFormState> {
    
    // services
    let api : ApiDataService = ApiDataService()
    let dataStore = InMemoryDataStore()
    let notificationManager = NotificationManager.shared
    
    // ui
    @Published var isUpdating = false
    
    // MARK: API functions
    
    func updateTree() {
        let treeModel = TreeModel(treeFormState: self.state)
        self.isUpdating = true
        api.updateTreeSubscription = api.updateTreeDetails(tree: treeModel)
            .sink {  [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Tree couldn't be updated\n(\(error.localizedDescription))",
                        type: .error)
                    break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Tree updated",
                        type: .success)
                    break
                }
                self?.isUpdating = false
            } receiveValue: { [weak self] (updatedTree) in
                let idStand = Int(self?.state.idStand ?? "") ?? 0
                let idTree = Int(self?.state.id ?? "") ?? 0
                if var treesForStands = self?.dataStore.treesForStands[idStand] {
                    treesForStands[idTree] = updatedTree
                }
            }
    }
    
    func cancelUpdate() {
        api.updateTreeSubscription?.cancel()
        self.isUpdating = false
    }
    
    // MARK: HANDLES FORM

    // MARK: - StateBindingViewModel Conformance
    
    override func stateWillChangeValue<Value>(
        _ keyPath: PartialKeyPath<TreeFormState>,
        newValue: Value
    ) -> Bool where Value: Equatable {
        return true
    }

    override func onStateChange(_ keyPath: PartialKeyPath<TreeFormState>) {
        // state.descriptionError = isValidDescription() ? nil : "description cannot be empty"
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
