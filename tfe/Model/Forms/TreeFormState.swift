//
//  TreeFormState.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

struct TreeFormState : Equatable {
    // let id = UUID()
    var id : String
    var idStand : String
    var latitude : String
    var longitude : String
    var description : String
    // extra fields
    var descriptionError : String?
    var isUpdateButtonEnabled: Bool = true
}

extension TreeFormState {
    init(tree: TreeModel) {
        id = String(tree.id)
        idStand = String(tree.idStand)
        latitude = String(tree.latitude)
        longitude = String(tree.longitude)
        description = String(tree.description)
    }
}
