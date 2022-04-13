//
//  InMemoryDataStore.swift
//  tfe
//
//  Created by martin d'hoedt on 4/7/22.
//

import Foundation
import Combine

class InMemoryDataStore : ObservableObject {
    private init() {}
    static let shared = InMemoryDataStore()
    
    @Published var allStands: [StandModel] = []
    @Published var historiesForStands: Dictionary<Int, [StandHistoryModel]> = Dictionary<Int, [StandHistoryModel]>()
    @Published var treesForStands: Dictionary<Int, [TreeModel]> = Dictionary<Int, [TreeModel]>()
    @Published var capturesForTrees: Dictionary<Int, [TreeCaptureModel]> = Dictionary<Int, [TreeCaptureModel]>()
    @Published var diametersForCaptures: Dictionary<Int, [DiameterModel]> = Dictionary<Int, [DiameterModel]>()
    
    func fetchAll() -> AnyPublisher<Bool, Never> {
        return Just(true).eraseToAnyPublisher()
    }
    
    func addStands(stands: [StandModel]) {
        allStands = stands.sorted()
    }
    
    func deleteStand(idStand: Int) {
        allStands.removeAll { stand in
            stand.id == stand.id
        }
    }
    
    func deleteTree(tree: TreeModel) {
        if treesForStands[tree.idStand] == nil {
            print("[InMemoryDataStore][deleteTree] stand not found")
            return
        }
        treesForStands[tree.idStand]!.removeAll { treeStored in
            return treeStored.id == tree.id
        }
    }
}
