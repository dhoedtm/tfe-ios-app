//
//  TreeCapturesVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//

import Foundation

final class TreeDetailsVM : ObservableObject {
    
    // services
    let api : ApiDataService = ApiDataService.shared
    let coreData = CoreDataService.shared
    let notificationManager = NotificationManager.shared
    
    // ui
    @Published var isUpdating : Bool = false
    @Published var isUpdateButtonEnabled : Bool = true
    @Published var descriptionError : String? = nil
    
    // data
    // TODO: find a way to auto-bind coredata entity properties to textfields
    var selectedTree : TreeEntity
    @Published var latitude : String = ""
    @Published var longitude : String = ""
    @Published var description : String = ""
    
    init(selectedTree: TreeEntity) {
        self.selectedTree = selectedTree
        self.latitude = String(selectedTree.latitude)
        self.longitude = String(selectedTree.longitude)
        self.description = selectedTree.treeDescription ?? ""
    }
    
    // MARK: HANDLES FORM

    private func isValidDescription() -> Bool {
        return !self.description.isEmpty
    }
    
    private func isValidForm() -> Bool {
        return isValidDescription()
    }
    
    // MARK: CORE DATA functions
    
    func updateTreeDetails() {
        self.isUpdating = true
        var treeModel = TreeModel(treeEntity: self.selectedTree)
        treeModel.description = self.description
        
        api.updateTreeSubscription = self.api.updateTreeDetails(tree: treeModel)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Tree couldn't be updated\n\(error.localizedDescription)",
                        type: .error
                    )
                break
                case .finished:
                    self?.notificationManager.notification = Notification(
                        message: "Tree has been updated",
                        type: .success
                    )
                break
                }
            }, receiveValue: { [weak self] treeModel in
                self?.coreData.updateLocalTreeDetails(treeModel: treeModel)
                self?.coreData.refreshLocalTreesForStand(id: (self?.selectedTree.idStand)!)
                self?.isUpdating = false
            })
    }
    
    func cancelUpdate() {
        api.updateTreeSubscription?.cancel()
        self.isUpdating = false
    }
}
