//
//  TreeFormState.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

struct TreeFormState : Equatable {
    var id : String
    var idStand : String
    var latitude : String
    var longitude : String
    var x : String
    var y : String
    var description : String
    var deletedAt : String
    // extra fields
    var descriptionError : String?
    var isUpdateButtonEnabled: Bool = true
}

extension TreeFormState {
    init(treeModel: TreeModel) {
        id = String(treeModel.id)
        idStand = String(treeModel.idStand)
        latitude = String(treeModel.latitude)
        longitude = String(treeModel.longitude)
        x = String(treeModel.x)
        y = String(treeModel.y)
        description = String(treeModel.description ?? "")
        deletedAt = treeModel.deletedAt ?? ""
    }
    
    init(treeEntity: TreeEntity) {
        id = String(treeEntity.id)
        idStand = String(treeEntity.idStand)
        latitude = String(treeEntity.latitude)
        longitude = String(treeEntity.longitude)
        x = String(treeEntity.x)
        y = String(treeEntity.y)
        description = String(treeEntity.treeDescription ?? "")
        deletedAt = treeEntity.deletedAt ?? ""
    }
    
    // used by Equatable
    static func ==(lhs: TreeFormState, rhs: TreeFormState) -> Bool {
        return lhs.id == rhs.id
    }
}
