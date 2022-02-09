//
//  MockAPIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

class MockAPIManager : ApiManaging {
    func getStands() -> [Stand] {
        var stands = [Stand]()
        stands.append(Stand(
            id: 1,
            name: "stand_1",
            filePath: "NaN",
            treeCount: 13,
            basalArea: 23.2,
            standDensity: 4,
            treePerAcre: 7,
            description: "my 1st stand"))
        stands.append(Stand(
            id: 2,
            name: "stand_2",
            filePath: "NaN",
            treeCount: 14,
            basalArea: 21.2,
            standDensity: 5,
            treePerAcre: 3,
            description: "my 2nd stand"))
        stands.append(Stand(
            id: 3,
            name: "stand_3",
            filePath: "NaN",
            treeCount: 5,
            basalArea: 4.6,
            standDensity: 1.3,
            treePerAcre: 2,
            description: "my 3rd stand"))
        return stands
    }
}
