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
    
    func reloadStandList() {
        withAnimation {
            self.isFetchingStands = true
            api.getStands()
        }
    }
    
    func uploadPointClouds(filePaths: [URL]) {
        for path in filePaths {
            print("[StandListVM][uploadPointClouds] uploading file : \(path)")

            api.uploadPointCloud(fileURL: path)
                .receive(on: OperationQueue.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("ERROR : \(error)")
                    }
                }) { uploadResponse in
                    switch uploadResponse {
                    case let .progress(percentage):
                        print("UPLOADING : \(percentage)")
                    case let .response(data):
                        print("RESPONDE : \(data)")
                    }
            }
        }
    }
    
    func deleteStand(offsets: IndexSet) {
        if let offset = offsets.first {
            let idStand = self.stands[offset].id
            api.deleteStand(idStand: idStand)
            self.stands.remove(atOffsets: offsets)
        }
    }
    
    func addSubscribers() {
        api.$allStands
            .sink { [weak self] (stands) in
                self?.stands = stands
                self?.isFetchingStands = false
            }
            .store(in: &cancellables)
    }
}
