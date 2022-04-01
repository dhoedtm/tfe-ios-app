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
            capturedAt: "2022-03-11T15:24:22.102033",
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
            capturedAt: "2022-01-12T14:14:33.102033",
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
            capturedAt: "2022-03-12T18:54:43.102033",
            description: "my 3rd stand"
        )
    ]
    
    static let trees : [TreeModel] = [
        TreeModel(id: 1, idStand: 1, latitude: 50.708228, longitude: 4.352911, description: "un arbre", deletedAt: "2022-01-04T11:14:06.102033"),
        TreeModel(id: 2, idStand: 1, latitude: 50.708239, longitude: 4.35288, description: "un arbre", deletedAt: "2022-02-06T10:09:11.102033"),
        TreeModel(id: 3, idStand: 1, latitude: 50.708262, longitude: 4.352855, description: "un arbre", deletedAt: "2022-05-06T09:16:12.102033"),
        TreeModel(id: 4, idStand: 1, latitude: 50.708251, longitude: 4.352834, description: "un arbre", deletedAt: "2022-07-07T15:13:33.102033"),
        TreeModel(id: 5, idStand: 1, latitude: 50.708251, longitude: 4.352862, description: "un arbre", deletedAt: "2022-09-11T16:18:23.102033"),
        TreeModel(id: 6, idStand: 1, latitude: 50.708262, longitude: 4.3528879, description: "un arbre", deletedAt: nil)
    ]
    
    static let captures : [TreeCaptureModel] = [
        TreeCaptureModel(id: 1, idTree: 1, dbh: 4.32, capturedAt: "2022-01-04T11:14:06.102033", basalArea: 432),
        TreeCaptureModel(id: 2, idTree: 1, dbh: 3.98, capturedAt: "2022-02-06T10:09:11.102033", basalArea: 564),
        TreeCaptureModel(id: 3, idTree: 1, dbh: 2.31, capturedAt: "2022-05-06T09:16:12.102033", basalArea: 756),
        TreeCaptureModel(id: 4, idTree: 1, dbh: 3.11, capturedAt: "2022-07-07T15:13:33.102033", basalArea: 43),
        TreeCaptureModel(id: 5, idTree: 1, dbh: 4.66, capturedAt: "2022-09-11T16:18:23.102033", basalArea: 72)
    ]
    
    static let dbhList : [Double] = [
        0.1232980326,
        0.1481883507,
        0.1809847701,
        0.2226622049,
        0.2280987701,
        0.2378328396,
        0.2553976090,
        0.2821024198,
        0.2969587937,
        0.3048599073,
        0.3195458490,
        0.3690479028
    ]
    
    static let basalAreaList : [Double] = [
        23.78328396,
        36.90479028,
        14.81883507,
        12.32980326,
        30.48599073,
        22.26622049,
        29.69587937,
        25.53976090,
        31.95458490,
        28.21024198,
        22.80987701,
        18.09847701
    ]
    
    static let chartData : [ChartData] = [
        ChartData(label: "16-11-2020",  value: 0.3048599073),
        ChartData(label: "18-11-2020",  value: 0.2969587937),
        ChartData(label: "20-11-2020",  value: 0.1809847701),
        ChartData(label: "21-11-2020",  value: 0.2821024198),
        ChartData(label: "25-11-2020",  value: 0.2553976090),
        ChartData(label: "28-11-2020",  value: 0.1232980326),
        ChartData(label: "4-12-2020",  value: 0.2378328396),
        ChartData(label: "10-12-2020",  value: 0.2226622049),
        ChartData(label: "19-12-2020",  value: 0.1481883507),
        ChartData(label: "24-12-2020",  value: 0.2280987701)
    ]
}
