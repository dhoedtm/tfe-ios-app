//
//  APIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

// TODO: add siesta / alamofire support

import Foundation
import Combine

class ApiDataService: NSObject {
    
    static let baseURL : URL? = URL(string: "http://tfe-dhoedt-castel.info.ucl.ac.be/api")
    
    // cancellables
    private var getStandsSubscription: AnyCancellable?
    private var getHistoriesSubscription: AnyCancellable?
    private var getTreesSubscription: AnyCancellable?
    private var getCapturesSubscription: AnyCancellable?
    private var getDiametersSubscription: AnyCancellable?
    
    private var updateTreeSubscription: AnyCancellable?
    private var updateStandSubscription: AnyCancellable?
    private var deleteTreeSubscription: AnyCancellable?
    private var deleteStandSubscription: AnyCancellable?
    
    private var uploadStandSubscription: AnyCancellable?
    
    @Published var allStands: [StandModel] = []
    @Published var historiesForStands: Dictionary<Int, [StandHistoryModel]> = Dictionary<Int, [StandHistoryModel]>()
    @Published var treesForStands: Dictionary<Int, [TreeModel]> = Dictionary<Int, [TreeModel]>()
    @Published var capturesForTrees: Dictionary<Int, [TreeCaptureModel]> = Dictionary<Int, [TreeCaptureModel]>()
    @Published var diametersForCaptures: Dictionary<Int, [DiameterModel]> = Dictionary<Int, [DiameterModel]>()
    
    func getStands() -> AnyPublisher<ApiResponse, ApiError> {
        let resourceString = "stands"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        getStandsSubscription = NetworkingManager.download(url: url)
            .mapError { error -> Error in
                return ApiError.unexpectedError(error)
            }
            .decode(type: [StandModel].self, decoder: JSONDecoder())
            .map({ stand in
                ApiResponse(data: stand, message: <#T##String?#>)
            })
            // .replaceError(with: [])
            .eraseToAnyPublisher()
        
//        sink(
//            receiveCompletion: NetworkingManager.handleCompletion,
//            receiveValue: { [weak self] (stands) in
//                self?.allStands = stands
//                self?.getStandsSubscription?.cancel()
//            }
//        )
    }
    
    func getTreesForStand(idStand: Int) {
        let resourceString = "stands/\(idStand)/trees"
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
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
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
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
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
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
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
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
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        guard let json = try? JSONEncoder().encode(stand) else {
            print("[updateStandDetails] JSON encoding error")
            return
        }
        
        updateStandSubscription = NetworkingManager.sendData(url: url, method: .PUT, data: json)
            .encode(encoder: JSONEncoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedStand) in
                    self?.updateStandSubscription?.cancel()
                }
            )
    }
    
    func updateTreeDetails(tree: TreeModel) {
        let resourceString = "trees/\(tree.id)"
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        guard let json = try? JSONEncoder().encode(tree) else {
            print("[updateTreeDetails] JSON encoding error")
            return
        }
        
        updateTreeSubscription = NetworkingManager.sendData(url: url, method: .PUT, data: json)
            .encode(encoder: JSONEncoder())
            // .replaceError(with: [])
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedTree) in
                    self?.updateTreeSubscription?.cancel()
                }
            )
    }
    
    func deleteStand(idStand: Int) {
        let resourceString = "stands/\(idStand)"
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
        deleteStandSubscription = NetworkingManager.sendData(url: url, method: .DELETE, data: nil)
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedData) in
                    self?.deleteStandSubscription?.cancel()
                }
            )
    }
    
    func deleteTree(idTree: Int) {
        let resourceString = "trees/\(idTree)"
        let url = ApiDataService.baseURL.appendingPathComponent(resourceString)
        
        deleteTreeSubscription = NetworkingManager.sendData(url: url, method: .DELETE, data: nil)
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedData) in
                    self?.deleteTreeSubscription?.cancel()
                }
            )
    }

    func uploadPointCloud(fileURL: URL) -> AnyPublisher<ApiResponse, ApiError> {
        return Just(ApiResponse(data: nil, message: "oopsie"))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
