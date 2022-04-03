//
//  DiameterModel.swift
//  tfe
//
//  Created by martin d'hoedt on 4/2/22.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct DiameterModel : Identifiable, Codable, Hashable {
    // let id = UUID()
    var id : Int
    var idTreeCapture : Int
    var diameter : Double
    var height : Double
}
