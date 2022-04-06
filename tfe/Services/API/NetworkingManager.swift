//
//  NetworkingManager.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import Foundation
import Combine

enum CustomError: Error {
    case notFound
    case unexpected(message: String)
}

//extension CustomError {
//    var isFatal: Bool {
//        if case CustomError.unexpected = self { return true }
//        else { return false }
//    }
//}

// For each error type return the appropriate description
extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound:
            return "The specified item could not be found."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString(
                "The specified item could not be found.",
                comment: "Resource Not Found"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}

class NetworkingManager {
    
//    static let baseURL : URL = URL(string: "http://192.168.1.11:3000/api/")!
    static let baseURL : URL = URL(string: "http://tfe-dhoedt-castel.info.ucl.ac.be/api")!
    
    enum HTTPMethods : String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        print("[NetworkingManager][download] STARTED : \(url)")
        // Combine framework uses publishers and subscribers
        // publishers should run on background threads
        // dataTaskPublisher already takes care of that for us
        let subscription = URLSession.shared.dataTaskPublisher(for: url)
        // .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher() // adds abstraction, now subscription is of type AnyPublisher<Data, Error>
        print("[NetworkingManager][download] DONE : \(url)")
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
        print("[handleCompletion] started")
        switch completion {
            case .finished:
                print("[handleCompletion] finished downloading")
            case .failure(let error):
                print("[handleCompletion] error downloading \(error)")
            }
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                print("[handleURLResponse] KO : \(url)")
                throw URLError(.badServerResponse)
            }
        print("[handleURLResponse] OK : \(url)")
        return output.data
    }
}
