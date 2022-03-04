//
//  Tree.swift
//  TFE
//
//  Created by user on 23/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct Tree : Identifiable {
    // let id = UUID()
    let id : Int
    var latitude : Double
    var longitude : Double
    let description : String
}

// init defined as extension to benefit from the defaut initializer
// provided by the framework
// the extension holds the functions whereas the main body of the struct is kept
// short and only contains the state variables
extension Tree {
    // JSON is a typealias for a Dictionnary String -> Any
    init?(json: JSON) {
        // returns nil if one of those keys is not defined
        guard
            let id = json["idTree"] as? Int,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double,
            let description = json["description"] as? String
        else {
            return nil
        }
        
        self.init(
            id:id, latitude:latitude, longitude:longitude, description: description
        )
    }
}
