//
//  MockAPIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

class MockAPIManager : APIManaging {
    
    func getStands() -> [Stand] {
        var stands = [Stand]()
        stands.append(Stand(
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
            captureDate: Date(),
            description: "my 1st stand",
            trees: []
        ))
        stands.append(Stand(
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
            captureDate: Date(),
            description: "my 2nd stand",
            trees: []
        ))
        stands.append(Stand(
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
            captureDate: Date(),
            description: "my 3rd stand",
            trees: []
        ))
        return stands
    }

    func getTreesFromStand(idStand: Int) -> [Tree] {
        switch idStand {
        case 1:
            return [
                Tree(id: 1, idStand: 1, latitude: 50.708228, longitude: 4.352911, description: "un arbre"),
                Tree(id: 2, idStand: 1, latitude: 50.708239, longitude: 4.35288, description: "un arbre"),
                Tree(id: 3, idStand: 1, latitude: 50.708262, longitude: 4.352855, description: "un arbre"),
                Tree(id: 4, idStand: 1, latitude: 50.708251, longitude: 4.352834, description: "un arbre"),
                Tree(id: 5, idStand: 1, latitude: 50.708251, longitude: 4.352862, description: "un arbre"),
                Tree(id: 6, idStand: 1, latitude: 50.708262, longitude: 4.3528879, description: "un arbre"),
            ]
        case 2:
            return [
                Tree(id: 1, idStand: 2, latitude: 50.708224, longitude: 4.352827, description: "un arbre")
            ]
        case 3:
            return []
        default:
            print("MockAPI couldn't find trees for idStand \(idStand)")
            return []
        }
    }

    func uploadPointCloud(filePath: URL) {
        print("MockAPI uploaded point cloud : \(filePath)")
    }
}

