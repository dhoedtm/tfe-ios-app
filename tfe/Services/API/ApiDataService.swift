//
//  APIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

// TODO: add siesta / alamofire support

import Foundation
import Combine

class ApiDataService {
    
    // cancellables
    private var getStandsSubscription: AnyCancellable?
    private var standsSubscription: AnyCancellable?
    private var getHistoriesSubscription: AnyCancellable?
    private var getTreesSubscription: AnyCancellable?
    private var getCapturesSubscription: AnyCancellable?
    private var getDiametersSubscription: AnyCancellable?
    
    @Published var allStands: [StandModel] = []
    @Published var historiesForStands: Dictionary<Int, [StandHistoryModel]> = Dictionary<Int, [StandHistoryModel]>()
    @Published var treesForStands: Dictionary<Int, [TreeModel]> = Dictionary<Int, [TreeModel]>()
    @Published var capturesForTrees: Dictionary<Int, [TreeCaptureModel]> = Dictionary<Int, [TreeCaptureModel]>()
    @Published var diametersForCaptures: Dictionary<Int, [DiameterModel]> = Dictionary<Int, [DiameterModel]>()
    
    func getStands() {
        let resourceString = "stands"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        getStandsSubscription = NetworkingManager.download(url: url)
            .decode(type: [StandModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (stands) in
                    self?.allStands = stands
                    self?.getStandsSubscription?.cancel()
                }
            )
    }
    
    func getTreesForStand(idStand: Int) {
        let resourceString = "stands/\(idStand)/trees"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        getTreesSubscription = NetworkingManager.download(url: url)
            .decode(type: [TreeModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (trees) in
                    self?.treesForStands[idStand] = trees
                    self?.getTreesSubscription?.cancel()
                }
            )
    }
    
    func getCapturesForTree(idTree: Int) {
        let resourceString = "trees/\(idTree)/tree_captures"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        getCapturesSubscription = NetworkingManager.download(url: url)
            .decode(type: [TreeCaptureModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (captures) in
                    self?.capturesForTrees[idTree] = captures
                    self?.getCapturesSubscription?.cancel()
                }
            )
    }
    
    func getHistoriesForStand(idStand: Int) {
        let resourceString = "stands/\(idStand)/histories"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        getCapturesSubscription = NetworkingManager.download(url: url)
            .decode(type: [StandHistoryModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (histories) in
                    self?.historiesForStands[idStand] = histories
                    self?.getHistoriesSubscription?.cancel()
                }
            )
    }
    
    func getDiametersForCapture(idCapture: Int) {
        let resourceString = "tree_captures/\(idCapture)/diameters"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        getCapturesSubscription = NetworkingManager.download(url: url)
            .decode(type: [DiameterModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (diameters) in
                    print("[getDiametersForCapture] \(idCapture) : \(diameters)")
                    self?.diametersForCaptures[idCapture] = diameters
                    self?.getDiametersSubscription?.cancel()
                }
            )
    }
    
    func updateStandDetails(stand: StandModel) {
        let resourceString = "stands/\(stand.id)"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        guard let json = try? JSONEncoder().encode(stand) else {
            print("[updateStandDetails] JSON encoding error")
            return
        }
        
        standsSubscription = NetworkingManager.sendData(url: url, method: .PUT, data: json)
            .encode(encoder: JSONEncoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedStand) in
                    self?.standsSubscription?.cancel()
                }
            )
    }
}
