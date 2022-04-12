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
    var getStandsSubscription: AnyCancellable?
    var getHistoriesSubscription: AnyCancellable?
    var getTreesSubscription: AnyCancellable?
    var getCapturesSubscription: AnyCancellable?
    var getDiametersSubscription: AnyCancellable?
    
    var updateTreeSubscription: AnyCancellable?
    var updateStandSubscription: AnyCancellable?
    var deleteTreeSubscription: AnyCancellable?
    var deleteStandSubscription: AnyCancellable?
    
    var uploadStandSubscription: AnyCancellable?
    
    func getStands() -> AnyPublisher<[StandModel], Error> {
        let resourceString = "stands"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.download(url: url)
            .mapError { error -> Error in
                return ApiError.unexpectedError(error)
            }
            .decode(type: [StandModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getTreesForStand(idStand: Int) -> AnyPublisher<[TreeModel], Error> {
        let resourceString = "stands/\(idStand)/trees"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.download(url: url)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: [TreeModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getCapturesForTree(idTree: Int) -> AnyPublisher<[TreeCaptureModel], Error> {
        let resourceString = "trees/\(idTree)/tree_captures"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.download(url: url)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: [TreeCaptureModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getHistoriesForStand(idStand: Int) -> AnyPublisher<[StandHistoryModel], Error> {
        let resourceString = "stands/\(idStand)/histories"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.download(url: url)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: [StandHistoryModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getDiametersForCapture(idCapture: Int) -> AnyPublisher<[DiameterModel], Error> {
        let resourceString = "tree_captures/\(idCapture)/diameters"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.download(url: url)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: [DiameterModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func updateStandDetails(stand: StandModel) -> AnyPublisher<StandModel, Error> {
        let resourceString = "stands/\(stand.id)"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        guard let json = try? JSONEncoder().encode(stand) else {
            return Fail(error: ApiError.invalidRequest("JSON encoding error"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.sendData(url: url, method: .PUT, data: json)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: StandModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func updateTreeDetails(tree: TreeModel) -> AnyPublisher<TreeModel, Error> {
        let resourceString = "trees/\(tree.id)"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        guard let json = try? JSONEncoder().encode(tree) else {
            return Fail(error: ApiError.invalidRequest("JSON encoding error"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.sendData(url: url, method: .PUT, data: json)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .decode(type: TreeModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func deleteStand(idStand: Int) -> AnyPublisher<Bool, Error> {
        let resourceString = "stands/\(idStand)"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        
        return NetworkingManager.sendData(url: url, method: .DELETE, data: nil)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .map({ data in
                true
            })
            .eraseToAnyPublisher()
    }
    
    func deleteTree(idTree: Int) -> AnyPublisher<Bool, Error> {
        let resourceString = "trees/\(idTree)"
        guard let url = ApiDataService.baseURL?.appendingPathComponent(resourceString) else {
            return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
        }
        return NetworkingManager.sendData(url: url, method: .DELETE, data: nil)
            .mapError { error -> Error in
                ApiError.unexpectedError(error)
            }
            .map({ data in
                true
            })
            .eraseToAnyPublisher()
    }

    func uploadPointCloud(fileURL: URL) -> AnyPublisher<Bool, ApiError> {
        return Fail(error: ApiError.invalidRequest("URL invalid"))
            .eraseToAnyPublisher()
    }
}
