//
//  StandMasterVM.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import Foundation
import SwiftUI

class StandMasterVM : ObservableObject {
    
    @Published var selectedStand : StandEntity
    
    init(selectedStand: StandEntity) {
        self.selectedStand = selectedStand
    }
}
