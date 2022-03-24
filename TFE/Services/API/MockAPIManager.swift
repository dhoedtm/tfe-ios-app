//
//  MockAPIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

//import Foundation
//
//class MockAPIManager : APIManaging {
//
//    func getStands(handler: @escaping TransferCompletion) {
//        var stands = [StandModel]()
//        stands.append(StandModel(
//            id: 1,
//            name: "stand_1_braine",
//            treeCount: 13,
//            basalArea: 23.2,
//            convexAreaMeter: 34,
//            convexAreaHectare: 23,
//            concaveAreaMeter: 45,
//            concaveAreaHectare: 33,
//            treeDensity: 5,
//            meanDbh: 2,
//            meanDistance: 898,
//            captureDate: "2022-03-11T15:24:22.102033",
//            description: "my 1st stand"
//        ))
//        stands.append(StandModel(
//            id: 2,
//            name: "stand_2_one_tree",
//            treeCount: 14,
//            basalArea: 21.2,
//            convexAreaMeter: 34,
//            convexAreaHectare: 23,
//            concaveAreaMeter: 45,
//            concaveAreaHectare: 33,
//            treeDensity: 5,
//            meanDbh: 2,
//            meanDistance: 898,
//            captureDate: "2022-01-12T14:14:33.102033",
//            description: "my 2nd stand"
//        ))
//        stands.append(StandModel(
//            id: 3,
//            name: "stand_3_empty",
//            treeCount: 5,
//            basalArea: 4.6,
//            convexAreaMeter: 34,
//            convexAreaHectare: 23,
//            concaveAreaMeter: 45,
//            concaveAreaHectare: 33,
//            treeDensity: 5,
//            meanDbh: 2,
//            meanDistance: 898,
//            captureDate: "2022-03-12T18:54:43.102033",
//            description: "my 3rd stand"
//        ))
//
//        let jsonData = try? JSONEncoder().encode(stands)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            handler(TransferResult(data: jsonData, error: nil))
//        }
//    }
//
//    func getTreesFromStand(idStand: Int, handler: @escaping TransferCompletion) {
//        var trees : [TreeModel]
//        switch idStand {
//        case 1:
//            trees = [
//                TreeModel(id: 1, idStand: 1, latitude: 50.708228, longitude: 4.352911, description: "un arbre"),
//                TreeModel(id: 2, idStand: 1, latitude: 50.708239, longitude: 4.35288, description: "un arbre"),
//                TreeModel(id: 3, idStand: 1, latitude: 50.708262, longitude: 4.352855, description: "un arbre"),
//                TreeModel(id: 4, idStand: 1, latitude: 50.708251, longitude: 4.352834, description: "un arbre"),
//                TreeModel(id: 5, idStand: 1, latitude: 50.708251, longitude: 4.352862, description: "un arbre"),
//                TreeModel(id: 6, idStand: 1, latitude: 50.708262, longitude: 4.3528879, description: "un arbre"),
//            ]
//        case 2:
//            trees = [
//                TreeModel(id: 1, idStand: 2, latitude: 50.708224, longitude: 4.352827, description: "un arbre")
//            ]
//        case 3:
//            trees = []
//        default:
//            print("MockAPI couldn't find trees for idStand \(idStand)")
//            trees = []
//        }
//
//        let jsonData = try? JSONEncoder().encode(trees)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            handler(TransferResult(data: jsonData, error: nil))
//        }
//    }
//
//    func uploadPointCloud(filePath: URL, handler: @escaping TransferCompletion) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            handler(TransferResult(data: nil, error: nil))
//            print("MockAPI uploaded point cloud : \(filePath)")
//        }
//    }
//}
