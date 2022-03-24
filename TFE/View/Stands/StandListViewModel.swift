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
        self.isFetchingStands = true
        api.getStands { (returnedResult) in
            DispatchQueue.main.async { [weak self] in
                if let data = returnedResult.data {
                    guard let stands = try? JSONDecoder().decode([Stand].self, from: data) else {
                        self?.error = "Could not decode JSON array"
                        self?.isFetchingStands = false
                        return
                    }
                    self?.stands = stands
                } else {
                    self?.error = returnedResult.error ?? "Unknown error occured"
                }
                self?.isFetchingStands = false
            }
        }
    }
    
    init() {
        self.getStands()
    }
}
