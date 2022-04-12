//
//  Tree.swift
//  TFE
//
//  Created by user on 23/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct TreeModel : Identifiable, Codable, Hashable, Comparable {
    // let id = UUID()
    var id : Int
    var idStand : Int
    var latitude : Double
    var longitude : Double
    var x : Double
    var y : Double
    var description : String?
    var deletedAt : String?
}

extension TreeModel {
    init() {
        id = 0
        idStand = 0
        latitude = 0
        longitude = 0
        x = 0
        y = 0
        description = nil
        deletedAt = nil
    }
    
    init(treeFormState: TreeFormState) {
//        guard
//            let id = Int(treeFormState.id),
//            let idStand = Int(treeFormState.idStand),
//            let latitude = Double(treeFormState.latitude),
//            let longitude = Double(treeFormState.longitude)
//        else {
//            // TODO: add throw ?
//        }
        
        id = Int(treeFormState.id) ?? 0
        idStand = Int(treeFormState.idStand) ?? 0
        latitude = Double(treeFormState.latitude) ?? 0
        longitude = Double(treeFormState.longitude) ?? 0
        x = Double(treeFormState.latitude) ?? 0
        y = Double(treeFormState.longitude) ?? 0
        description = treeFormState.description.isEmpty ? nil : treeFormState.description
        deletedAt = treeFormState.deletedAt.isEmpty ? nil : treeFormState.deletedAt
    }
    
    static func < (lhs: TreeModel, rhs: TreeModel) -> Bool {
        lhs.id < rhs.id
    }
}
