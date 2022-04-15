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
    
    private let api = ApiDataService.shared
    
    @Published var allStands: [StandModel] = []
    @Published var historiesForStands: Dictionary<Int, [StandHistoryModel]> = Dictionary<Int, [StandHistoryModel]>()
    @Published var treesForStands: Dictionary<Int, [TreeModel]> = Dictionary<Int, [TreeModel]>()
    @Published var capturesForTrees: Dictionary<Int, [TreeCaptureModel]> = Dictionary<Int, [TreeCaptureModel]>()
    @Published var diametersForCaptures: Dictionary<Int, [DiameterModel]> = Dictionary<Int, [DiameterModel]>()
    
//    func fetchAll() -> AnyPublisher<Bool, Error> {
//        // fetches stands from API
//        // upon reception of the stands, fetches trees for each stand
//        // upon reception of the stands, fetches histories for each stand
//        // upon reception of the trees, fetches captures for each tree
//        // upon reception of the captures, fetches diameters for each tree
//
//    }
    
    // MARK: fetchers
    
    func getStands() -> AnyPublisher<Bool, Error> {
        return api.getStands()
            .flatMap { stands -> AnyPublisher<Bool, Error> in
                self.allStands = stands.sorted()
                return CurrentValueSubject<Bool, Error>(true).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: modifiers
    
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
