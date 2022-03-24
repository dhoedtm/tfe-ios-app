//
//  APIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

// TODO: add siesta / alamofire support

import Foundation
import Combine

class StandDataService {
    
    enum ApiResource {
        case stand
        case tree
        
        var name: String? {
            switch self {
            case .stand: return "stand"
            case .tree: return "tree"
            }
        }
        var model: Any? {
            switch self {
            case .stand: return StandModel.self
            case .tree: return TreeModel.self
            }
        }
    }
    
    // cancellables
    var standSubscription: AnyCancellable?
    
    @Published var allStands: [StandModel] = []
    @Published var treesForStands: Dictionary<Int, [TreeModel]> = Dictionary<Int, [TreeModel]>()
    
    func getStands() {
        let resourceString = "stands"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        standSubscription = NetworkingManager.download(url: url)
            .decode(type: [StandModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (stands) in
                self?.allStands = stands
                self?.standSubscription?.cancel()
            })
    }
    
    func getTreesForStand(idStand: Int) {
        let resourceString = "stands/\(idStand)/trees"
        let url = NetworkingManager.baseURL.appendingPathComponent(resourceString)
        
        standSubscription = NetworkingManager.download(url: url)
            .decode(type: [TreeModel].self, decoder: JSONDecoder())
            // .replaceError(with: [])
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (trees) in
                self?.treesForStands[idStand] = trees
                self?.standSubscription?.cancel()
            })
    }
}
