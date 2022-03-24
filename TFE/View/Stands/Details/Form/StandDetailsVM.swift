//
//  StandDetailsVM.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class StandDetailsVM : ObservableObject {
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var error : String? = nil
    
    @Published var selectedStand : StandModel
    
    init(selectedStand: StandModel) {
        self.selectedStand = selectedStand
    }
    
    func updateStandDetails() {
        api.updateStandDetails(stand: self.selectedStand)
    }
    
    func uploadStandPointCloud(filePath: URL) {
        print("uploading file : \(filePath)")
    }
}
