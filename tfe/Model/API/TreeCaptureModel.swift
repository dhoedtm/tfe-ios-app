//
//  TreeCapture.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct TreeCaptureModel : Identifiable, Codable, Hashable {
    // let id = UUID()
    var id : Int
    var idTree : Int
    var dbh : Double
    var basalArea : Double
    var capturedAt : String
}

extension TreeCaptureModel {
    init() {
        self.id = 0
        self.idTree = 0
        self.dbh = 0
        self.basalArea = 0
        self.capturedAt = ""
    }
}