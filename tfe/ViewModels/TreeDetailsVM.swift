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
    @Published var isUpdating = false
    @Published var isUpdateButtonEnabled = false
    @Published var descriptionError : String? = nil
    
    // data
    // TODO: find a way to auto-bind coredata entity properties to textfields
    var selectedTree : TreeEntity
    @Published var id : String = ""
    @Published var idStand : String = ""
    @Published var latitude : String = ""
    @Published var longitude : String = ""
    @Published var x : String = ""
    @Published var y : String = ""
    @Published var description : String = ""
    @Published var deletedAt : String = ""
    
    init(selectedTree: TreeEntity) {
        self.selectedTree = selectedTree
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
        print("TODO : [TreeDetailsVM][updateTreeDetails]")
    }
    
    func cancelUpdate() {
        api.updateTreeSubscription?.cancel()
        self.isUpdating = false
    }
}
