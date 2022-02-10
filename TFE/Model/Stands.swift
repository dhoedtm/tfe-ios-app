//
//  Stands.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

struct Stand {
    let id : Int
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
    init?(json: JSON) {
        // returns nil if one of those keys is not defined
        guard
            let id = json["idStand"] as? Int,
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
            id:id, name:name, filePath: filePath, treeCount: treeCount, basalArea:basalArea,
            standDensity: standDensity, treePerAcre:treePerAcre, description: description
        )
    }
}
