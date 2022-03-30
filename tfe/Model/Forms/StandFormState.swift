//
//  StandFormState.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//

import Foundation

struct StandFormState : Equatable {
    var id: String
    var name: String
    var treeCount: String
    var basalArea: String
    var convexAreaMeter: String
    var convexAreaHectare: String
    var concaveAreaMeter: String
    var concaveAreaHectare: String
    var treeDensity: String
    var meanDbh: String
    var meanDistance: String
    var captureDate: String
    var description: String
    // extra fields
    var nameError : String?
    var descriptionError : String?
    var isUpdateButtonEnabled: Bool = true
}

extension StandFormState {
    init(stand: StandModel) {
        id = String(stand.id)
        name = String(stand.name)
        treeCount = String(stand.treeCount)
        basalArea = String(stand.basalArea)
        convexAreaMeter = String(stand.convexAreaMeter)
        convexAreaHectare = String(stand.convexAreaHectare)
        concaveAreaMeter = String(stand.concaveAreaMeter)
        concaveAreaHectare = String(stand.concaveAreaHectare)
        treeDensity = String(stand.treeDensity)
        meanDbh = String(stand.meanDbh)
        meanDistance = String(stand.meanDistance)
        captureDate = String(stand.captureDate)
        description = String(stand.description)
    }
    
    // used by Equatable
    static func ==(lhs: StandFormState, rhs: StandFormState) -> Bool {
        return lhs.id == rhs.id
    }
}
