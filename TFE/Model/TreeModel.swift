//
//  Tree.swift
//  TFE
//
//  Created by user on 23/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct TreeModel : Identifiable, Codable, Hashable {
    // let id = UUID()
    let id : Int
    let idStand : Int
    var latitude : Double
    var longitude : Double
    let description : String
}
