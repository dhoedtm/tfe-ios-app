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
    
    @Published var stands : [Stand]
    @Published var selectedStand : Stand?
    
    init() {
        let stands = api.getStands()
        self.stands = stands
        
        // TODO: messy, amount of if statements would grow with deeper levels of nested data
        // could use alamofire to better handle missing/empty data ?
        if let firstStand = stands.first {
            self.selectedStand = firstStand
        } else {
            print("no stand could be selected as the retrieved stands list is empty")
            self.selectedStand = nil
        }
    }
}
