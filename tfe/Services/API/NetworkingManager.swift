//
//  NetworkingManager.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import Foundation
import Combine

class NetworkingManager {
    
    static let baseURL : URL = URL(string: "http://192.168.1.11:3000/api/")!
//    static let baseURL : URL = URL(string: "http://tfe-dhoedt-castel.info.ucl.ac.be/api/")!
    
    enum HTTPMethods : String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        print("[NetworkingManager][download] \(url)")
        // Combine framework uses publishers and subscribers
        // publishers should run on background threads
        // dataTaskPublisher already takes care of that for us
        let subscription = URLSession.shared.dataTaskPublisher(for: url)
        // .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher() // adds abstraction, now subscription is of type AnyPublisher<Data, Error>
        return subscription
    }
    
    static func sendData(url: URL, method: HTTPMethods, data: Data) -> AnyPublisher<Data, Error> {
        print("[NetworkingManager][sendData] \(url) \(method.rawValue)")
        // Combine framework uses publishers and subscribers
        // publishers should run on background threads
        // dataTaskPublisher already takes care of that for us
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        let subscription = URLSession.shared.dataTaskPublisher(for: request)
        // .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher() // adds abstraction, now subscription is of type AnyPublisher<Data, Error>
        return subscription
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                print("[handleCompletion] finished downloading")
            case .failure(let error):
                print("[handleCompletion] error downloading \(error.localizedDescription)")
            }
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                print("[handleURLResponse] \(url)")
                throw URLError(.badServerResponse)
            }
        return output.data
    }
}
