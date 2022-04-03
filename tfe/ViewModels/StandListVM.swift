//
//  StandListVM.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class StandListVM : ObservableObject {
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isFetchingStands : Bool = false
    @Published var error : String? = nil
    
    @Published var stands : [StandModel] = []
    @Published var selectedStand : StandModel?
    
    init() {
        addSubscribers()
        api.getStands()
        self.isFetchingStands = true
    }
    
    func addSubscribers() {
        api.$allStands
            .sink { [weak self] (stands) in
                self?.stands = stands
                self?.isFetchingStands = false
            }
            .store(in: &cancellables)
    }
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            print("[uploadPointClouds] uploading file : \(path)")
//            api.uploadPointCloud(filePath: path) { [weak self] (returnedResult) in
//                // TODO
//            }
        }
    }
}
