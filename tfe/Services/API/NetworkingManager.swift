//
//  NetworkingManager.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum HTTPMethods : String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
//        print("[NetworkingManager][download] \(url)")
        if (!Reachability.isConnectedToNetwork()) {
            return Fail(error: ApiError.noInternetAccess(""))
                .eraseToAnyPublisher()
        }
        
        let subscription = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
        return subscription
    }
    
    static func sendData(url: URL, method: HTTPMethods, data: Data?) -> AnyPublisher<Data, Error> {
        print("[NetworkingManager][sendData][\(method.rawValue)] \(url)")
        if (!Reachability.isConnectedToNetwork()) {
            return Fail(error: ApiError.noInternetAccess(""))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let data = data {
            request.httpBody = data
        }
        let subscription = URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
        return subscription
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                break
        case .failure: // (let error):
                break
        }
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
}
