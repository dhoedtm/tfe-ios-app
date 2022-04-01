//
//  TreeCaptureFormState.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//

import Foundation

struct TreeCaptureFormState : Equatable {
    var id : String
    var idTree : String
    var dbh : String
    var capturedAt : String
    var basalArea : String
    // extra fields
}

extension TreeCaptureFormState {
    init(tree: TreeCaptureModel) {
        id = String(tree.id)
        idTree = String(tree.idTree)
        dbh = String(tree.dbh)
        capturedAt = String(tree.capturedAt)
        basalArea = String(tree.basalArea)
    }
    
    // used by Equatable
    static func ==(lhs: TreeCaptureFormState, rhs: TreeCaptureFormState) -> Bool {
        return lhs.id == rhs.id
    }
}
