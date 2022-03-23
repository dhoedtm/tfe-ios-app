//
//  APIManager.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

// TODO: add siesta / alamofire support

import Foundation

class APIManager : APIManaging {
    
    private let BaseURL : URL = URL(string: "http://192.168.1.11:3000/api/")!
    
    enum Resource : String {
        case stands
        case trees
    }
    
//    func getData(resource: Resource, handler: @escaping DownloadCompletion) {
//        let resourceString = resource.rawValue
//        let url = BaseURL.appendingPathComponent(resourceString)
//        // dataTask : executes on a background thread
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print("[API] couldn't get \(resourceString) : no data")
//                return
//            }
//            if let error = error {
//                print("[API] couldn't get \(resourceString) : error \(error)")
//                return
//            }
//            guard let response = response as? HTTPURLResponse else {
//                print("[API] couldn't get \(resourceString) : invalid response")
//                return
//            }
//            guard response.statusCode >= 200 && response.statusCode < 300 else {
//                print("[API] couldn't get \(resourceString) : bad response code \(response.statusCode)")
//                return
//            }
//
//            guard let result = try? JSONDecoder().decode(Stand.self, from: data) else { return }
//
//            handler(data: response, error: error)
//        }.resume() // starts the task
//    }
    
    func getStands(handler: @escaping TransferCompletion) {
        let resourceString = "stands"
        let url = BaseURL.appendingPathComponent(resourceString)
        // dataTask : executes on a background thread
        
        print("getStands from api started")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                print("[API] couldn't get \(resourceString) : invalid response")
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("[API] couldn't get \(resourceString) : bad response code \(response.statusCode)")
                return
            }
            guard let data = data else {
                print("[API] couldn't get \(resourceString) : no data")
                return
            }
            
            var errorMessage : String? = nil
            if let error = error {
                errorMessage = error.localizedDescription
//                print("[API] couldn't get \(resourceString) : error \(error)")
//                return
            }
            
            print("getStands from api handler")
            handler(TransferResult(data: data, error: errorMessage))
            print("getStands from api ended")
        }.resume() // starts the task
    }
    
    func getTreesFromStand(idStand: Int, handler: @escaping TransferCompletion) {
        fatalError("not implemented")
    }
    
    func uploadPointCloud(filePath: URL, handler: @escaping TransferCompletion) {
        fatalError("not implemented")
    }
}
