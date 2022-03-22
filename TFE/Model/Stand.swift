//
//  Stands.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
struct Stand : Identifiable {
    // let id = UUID()
    let id : Int
    let name : String
    let treeCount : Int
    let basalArea : Double
    let convexAreaMeter: Double
    let convexAreaHectare: Double
    let concaveAreaMeter: Double
    let concaveAreaHectare: Double    
    let treeDensity: Double
    let meanDbh: Double
    let meanDistance: Double
    let captureDate: Date
    let description : String
    let trees : [Tree]
}

// init defined as extension to benefit from the defaut initializer
// provided by the framework
// the extension holds the functions whereas the main body of the struct is kept
// short and only contains the state variables
extension Stand {
    // JSON is a typealias for a Dictionnary String -> Any
    init?(json: JSON) {
        // returns nil if one of those keys is not defined
        guard
            let id = json["idStand"] as? Int,
            let name = json["name"] as? String,
            let treeCount = json["treeCount"] as? Int,
            let basalArea = json["basalArea"] as? Double,
            let convexAreaMeter = json["convexAreaMeter"] as? Double,
            let convexAreaHectare = json["convexAreaHectare"] as? Double,
            let concaveAreaMeter = json["concaveAreaMeter"] as? Double,
            let concaveAreaHectare = json["concaveAreaHectare"] as? Double,
            let treeDensity = json["treeDensity"] as? Double,
            let meanDbh = json["meanDbh"] as? Double,
            let meanDistance = json["meanDistance"] as? Double,
            let captureDate = DateParser.parse(date: json["captureDate"] as! String),
            let description = json["description"] as? String,
            let trees = json["trees"] as? [Tree]
        else {
            return nil
        }
        
        self.init(
            id: id, name:name, treeCount: treeCount, basalArea: basalArea, convexAreaMeter: convexAreaMeter, convexAreaHectare: convexAreaHectare, concaveAreaMeter: concaveAreaMeter, concaveAreaHectare: concaveAreaHectare, treeDensity: treeDensity, meanDbh: meanDbh, meanDistance: meanDistance, captureDate: captureDate, description: description, trees: trees
        )
    }
}
