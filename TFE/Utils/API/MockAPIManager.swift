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
            filePath: "NaN",
            treeCount: 13,
            basalArea: 23.2,
            standDensity: 4,
            treePerAcre: 7,
            description: "my 1st stand",
            trees: []
        ))
        stands.append(Stand(
            id: 2,
            name: "stand_2_one_tree",
            filePath: "NaN",
            treeCount: 14,
            basalArea: 21.2,
            standDensity: 5,
            treePerAcre: 3,
            description: "my 2nd stand",
            trees: []
        ))
        stands.append(Stand(
            id: 3,
            name: "stand_3_empty",
            filePath: "NaN",
            treeCount: 5,
            basalArea: 4.6,
            standDensity: 1.3,
            treePerAcre: 2,
            description: "my 3rd stand",
            trees: []
        ))
        return stands
    }

    func getTreesFromStand(idStand: Int) -> [Tree] {
        switch idStand {
        case 1:
            return [
                Tree(id: 1, latitude: 50.708228, longitude: 4.352911, description: "un arbre"),
                Tree(id: 2, latitude: 50.708239, longitude: 4.35288, description: "un arbre"),
                Tree(id: 3, latitude: 50.708262, longitude: 4.352855, description: "un arbre"),
                Tree(id: 4, latitude: 50.708251, longitude: 4.352834, description: "un arbre"),
                Tree(id: 5, latitude: 50.708251, longitude: 4.352862, description: "un arbre"),
                Tree(id: 6, latitude: 50.708262, longitude: 4.3528879, description: "un arbre"),
            ]
        case 2:
            return [
                Tree(id: 1, latitude: 50.708224, longitude: 4.352827, description: "un arbre")
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

