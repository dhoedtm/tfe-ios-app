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
        print("[NetworkingManager][download] \(url)")
        // Combine framework uses publishers and subscribers
        // publishers should run on background threads
        // dataTaskPublisher already takes care of that for us
        let subscription = URLSession.shared.dataTaskPublisher(for: url)
        // .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher() // adds abstraction, now subscription is of type AnyPublisher<Data, Error>
//        print("[NetworkingManager][download] DONE : \(url)")
        return subscription
    }
    
    static func sendData(url: URL, method: HTTPMethods, data: Data?) -> AnyPublisher<Data, Error> {
        print("[NetworkingManager][sendData][\(method.rawValue)] \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let data = data {
            request.httpBody = data
        }
        let subscription = URLSession.shared.dataTaskPublisher(for: request)
        // .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher() // adds abstraction, now subscription is of type AnyPublisher<Data, Error>
        return subscription
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
//        print("[handleCompletion] started")
        switch completion {
            case .finished:
//                print("[handleCompletion] finished")
                break
        case .failure: // (let error):
//                print("[handleCompletion] error : \(error)")
                break
        }
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
//                print("[handleURLResponse] KO : \(url)")
                throw URLError(.badServerResponse)
            }
//        print("[handleURLResponse] OK : \(url)")
        return output.data
    }
    
    static func createFormdataBodyData(data: Data, boundary: String, fileName: String) -> Data {
        var fullData = Data()
        
        fullData.append(
            "--\(boundary)\r\n".data(using: .utf8)!
        )
        fullData.append(
            "Content-Disposition: form-data; name=\"georeferenced\"; filename=\"parcelle_test_precision_12_04_36.laz\"\r\n".data(using: .utf8)!
        )
        fullData.append(
            "Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!
        )
        fullData.append(
            data
        )
//        fullData.append(
//            "\r\n".data(using: .utf8)!
//        )
        fullData.append(
            "\r\n--\(boundary)--\r\n".data(using: .utf8)!
        )
        
        return fullData
    }
}
