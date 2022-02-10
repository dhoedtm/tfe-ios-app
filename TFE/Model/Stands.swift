//
//  Stands.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, key "id" initiliazed with UUID()
// could use actual "standId" but better to semantically separate the two
struct Stand : Identifiable {
    let id = UUID()
    let idStand : Int
    let name : String
    let filePath : String
    let treeCount : Int
    let basalArea : Double
    let standDensity : Double
    let treePerAcre : Double
    let description : String
}

// init defined as extension to benefit from the defaut initializer
// provided by the framework
extension Stand {
    // JSON is a typealias for a Dictionnary String -> Any
    init?(json: JSON) {
        // returns nil if one of those keys is not defined
        guard
            let idStand = json["idStand"] as? Int,
            let name = json["name"] as? String,
            let filePath = json["filePath"] as? String,
            let treeCount = json["treeCount"] as? Int,
            let basalArea = json["basalArea"] as? Double,
            let standDensity = json["standDensity"] as? Double,
            let treePerAcre = json["treePerAcre"] as? Double,
            let description = json["description"] as? String
        else {
            return nil
        }
        
        self.init(
            idStand:idStand, name:name, filePath: filePath, treeCount: treeCount, basalArea:basalArea, standDensity: standDensity, treePerAcre:treePerAcre, description: description
        )
    }
}
