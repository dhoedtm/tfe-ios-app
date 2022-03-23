//
//  StandListViewModel.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import MapKit
import SwiftUI

class StandListViewModel : ObservableObject {
    
    let api = container.resolve(APIManaging.self)!
    
    @Published var isFetchingStands : Bool = false
    @Published var error : String? = nil
    @Published var stands : [Stand] = [Stand]()
    @Published var selectedStand : Stand?
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            api.uploadPointCloud(filePath: path) { [weak self] (returnedResult) in
                // TODO
            }
        }
    }
    
    func getStands() {
        print("getStands from VM started")
        self.isFetchingStands = true
        api.getStands { (returnedResult) in
            DispatchQueue.main.async { [weak self] in
                print("getStands from VM main thread handling started")
                
                if let data = returnedResult.data {
                    print(String(data: data, encoding: .utf8))
                    do {
                        let stands = try JSONDecoder().decode([Stand].self, from: data)
                        self?.stands = stands
                    } catch {
                        self?.isFetchingStands = false
                    }
                } else {
                    self?.error = returnedResult.error ?? "Unknown error occured"
                }
                print("getStands from VM ended")
                self?.isFetchingStands = false
            }
        }
    }
    
    init() {
        self.getStands()
    }
}
