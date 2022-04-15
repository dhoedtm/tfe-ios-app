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
    var capturedAt: String
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
        capturedAt = String(stand.capturedAt)
        description = String(stand.description ?? "")
    }
    
    init(standEntity: StandEntity) {
        id = String(standEntity.id)
        name = standEntity.name ?? ""
        treeCount = String(standEntity.treeCount)
        basalArea = String(standEntity.basalArea)
        convexAreaMeter = String(standEntity.convexAreaMeter)
        convexAreaHectare = String(standEntity.convexAreaHectare)
        concaveAreaMeter = String(standEntity.concaveAreaMeter)
        concaveAreaHectare = String(standEntity.concaveAreaHectare)
        treeDensity = String(standEntity.treeDensity)
        meanDbh = String(standEntity.meanDbh)
        meanDistance = String(standEntity.meanDistance)
        capturedAt = standEntity.capturedAt ?? ""
        description = standEntity.standDescription ?? ""
    }
    
    // used by Equatable
    static func ==(lhs: StandFormState, rhs: StandFormState) -> Bool {
        return lhs.id == rhs.id
    }
}
