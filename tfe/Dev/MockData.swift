//
//  MockData.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation

class MockData {
    static let stands: [StandModel] = [
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
    
    static let trees: [TreeModel] = [
        TreeModel(id: 1, idStand: 1, latitude: 50.708228, longitude: 4.352911, x: 50.708228, y: 4.352911, description: "un arbre", deletedAt: "2022-01-04T11:14:06.102033"),
        TreeModel(id: 2, idStand: 1, latitude: 50.708239, longitude: 4.35288, x: 50.708239, y: 4.35288, description: "un arbre", deletedAt: nil),
        TreeModel(id: 3, idStand: 1, latitude: 50.708262, longitude: 4.352855, x: 50.708262, y: 4.352855, description: "un arbre", deletedAt: "2022-05-06T09:16:12.102033"),
        TreeModel(id: 4, idStand: 1, latitude: 50.708251, longitude: 4.352834, x: 50.708251, y: 4.352834, description: "un arbre", deletedAt: nil),
        TreeModel(id: 5, idStand: 1, latitude: 50.708251, longitude: 4.352862, x: 50.708251, y: 4.352862, description: "un arbre", deletedAt: "2022-09-11T16:18:23.102033"),
        TreeModel(id: 6, idStand: 1, latitude: 50.708262, longitude: 4.3528879, x: 50.708262, y: 4.3528879, description: "un arbre", deletedAt: nil)
    ]
    
    static let dbhList: [Double] = [
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
    
    static let basalAreaList: [Double] = [
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
    
    static let chartData: [ChartData] = [
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
    
    static let captures: [TreeCaptureModel] = [
        TreeCaptureModel(
            id: 1,
            idTree: 4,
            dbh: 0.182883991443278,
            basalArea: 0.02626886233979008,
            capturedAt: "2022-03-31T23:33:11.124122"
        ),
        TreeCaptureModel(
            id: 2,
            idTree: 4,
            dbh: 0.19354394387593,
            basalArea: 0.028202985493094,
            capturedAt: "2022-04-05T09:13:33.124122"
        ),
        TreeCaptureModel(
            id: 3,
            idTree: 4,
            dbh: 0.24857349587378,
            basalArea: 0.034432376987956,
            capturedAt: "2022-05-21T16:32:23.124122"
        ),
        TreeCaptureModel(
            id: 4,
            idTree: 4,
            dbh: 0.29345938094345,
            basalArea: 0.0394537234587,
            capturedAt: "2022-06-11T13:25:01.124122"
        )
    ]
    
    static let diameters: [DiameterModel] = [
        DiameterModel(
            id: 1,
            idTreeCapture: 1,
            diameter: 0.257997475000044,
            height: 0.14667731629393
        ),
        DiameterModel(
            id: 2,
            idTreeCapture: 1,
            diameter: 0.200903481473946,
            height: 0.37736568457539
        ),
        DiameterModel(
            id: 3,
            idTreeCapture: 1,
            diameter: 0.21605843844643402,
            height: 0.619337349397591
        ),
        DiameterModel(
            id: 4,
            idTreeCapture: 1,
            diameter: 0.21233211980933803,
            height: 0.86672131147541
        ),
        DiameterModel(
            id: 5,
            idTreeCapture: 1,
            diameter: 0.246940719477388,
            height: 1.11681818181818
        ),
        DiameterModel(
            id: 6,
            idTreeCapture: 1,
            diameter: 0.21634379812961602,
            height: 1.37325619834711
        ),
        DiameterModel(
            id: 7,
            idTreeCapture: 1,
            diameter: 0.264198346078644,
            height: 1.61860696517413
        ),
        DiameterModel(
            id: 8,
            idTreeCapture: 1,
            diameter: 0.26128803631908804,
            height: 1.85364464692483
        ),
        DiameterModel(
            id: 9,
            idTreeCapture: 1,
            diameter: 0.20170099301050404,
            height: 2.09502008032129
        )
    ]
    
    static let standHistories = [
        StandHistoryModel(
            id: 1,
            name: "stand_1_braine",
            treeCount: 13,
            basalArea: 23.2,
            convexAreaMeter: 34,
            convexAreaHectare: 13,
            concaveAreaMeter: 46,
            concaveAreaHectare: 31,
            treeDensity: 5.5,
            meanDbh: 2.3,
            meanDistance: 890,
            capturedAt: "2022-03-11T15:24:22.102033",
            description: "my 1st stand"
        ),
        StandHistoryModel(
            id: 2,
            name: "stand_2_one_tree",
            treeCount: 14,
            basalArea: 21.2,
            convexAreaMeter: 31,
            convexAreaHectare: 20,
            concaveAreaMeter: 41,
            concaveAreaHectare: 39,
            treeDensity: 6.3,
            meanDbh: 2.2,
            meanDistance: 798,
            capturedAt: "2022-01-12T14:14:33.102033",
            description: "my 2nd stand"
        ),
        StandHistoryModel(
            id: 3,
            name: "stand_3_empty",
            treeCount: 10,
            basalArea: 4.3,
            convexAreaMeter: 32.3,
            convexAreaHectare: 19,
            concaveAreaMeter: 44,
            concaveAreaHectare: 29,
            treeDensity: 3,
            meanDbh: 5,
            meanDistance: 812,
            capturedAt: "2022-03-12T18:54:43.102033",
            description: "my 3rd stand"
        )
    ]
}
