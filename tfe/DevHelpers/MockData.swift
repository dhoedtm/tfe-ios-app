//
//  MockData.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation

class MockData {
    static let stands : [StandModel] = [
        StandModel(
            id: 1,
            name: "stand_1_braine",
            treeCount: 13,
            basalArea: 23.2,
            convexAreaMeter: 34,
            convexAreaHectare: 23,
            concaveAreaMeter: 45,
            concaveAreaHectare: 33,
            treeDensity: 5,
            meanDbh: 2,
            meanDistance: 898,
            captureDate: "2022-03-11T15:24:22.102033",
            description: "my 1st stand"
        ),
        StandModel(
            id: 2,
            name: "stand_2_one_tree",
            treeCount: 14,
            basalArea: 21.2,
            convexAreaMeter: 34,
            convexAreaHectare: 23,
            concaveAreaMeter: 45,
            concaveAreaHectare: 33,
            treeDensity: 5,
            meanDbh: 2,
            meanDistance: 898,
            captureDate: "2022-01-12T14:14:33.102033",
            description: "my 2nd stand"
        ),
        StandModel(
            id: 3,
            name: "stand_3_empty",
            treeCount: 5,
            basalArea: 4.6,
            convexAreaMeter: 34,
            convexAreaHectare: 23,
            concaveAreaMeter: 45,
            concaveAreaHectare: 33,
            treeDensity: 5,
            meanDbh: 2,
            meanDistance: 898,
            captureDate: "2022-03-12T18:54:43.102033",
            description: "my 3rd stand"
        )
    ]
    
    static let trees : [TreeModel] = [
        TreeModel(id: 1, idStand: 1, latitude: 50.708228, longitude: 4.352911, description: "un arbre"),
        TreeModel(id: 2, idStand: 1, latitude: 50.708239, longitude: 4.35288, description: "un arbre"),
        TreeModel(id: 3, idStand: 1, latitude: 50.708262, longitude: 4.352855, description: "un arbre"),
        TreeModel(id: 4, idStand: 1, latitude: 50.708251, longitude: 4.352834, description: "un arbre"),
        TreeModel(id: 5, idStand: 1, latitude: 50.708251, longitude: 4.352862, description: "un arbre"),
        TreeModel(id: 6, idStand: 1, latitude: 50.708262, longitude: 4.3528879, description: "un arbre")
    ]
    
    
    static let captures : [TreeCaptureModel] = [
        TreeCaptureModel(id: 1, idTree: 1, dbh: 4.32, captureDate: "2022-01-04T11:14:06.102033", basalArea: 432),
        TreeCaptureModel(id: 2, idTree: 1, dbh: 3.98, captureDate: "2022-02-06T10:09:11.102033", basalArea: 564),
        TreeCaptureModel(id: 3, idTree: 1, dbh: 2.31, captureDate: "2022-05-06T09:16:12.102033", basalArea: 756),
        TreeCaptureModel(id: 4, idTree: 1, dbh: 3.11, captureDate: "2022-07-07T15:13:33.102033", basalArea: 43),
        TreeCaptureModel(id: 5, idTree: 1, dbh: 4.66, captureDate: "2022-09-11T16:18:23.102033", basalArea: 72)
    ]
}
