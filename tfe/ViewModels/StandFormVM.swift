//
//  StandFormVM.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import Foundation

import Foundation
import SwiftUI

class StandFormVM : ObservableObject {
    
    @Published var selectedStand : StandModel
    
    init(selectedStand: StandModel) {
        self.selectedStand = selectedStand
    }
    
    func updateStand(stand: StandModel) {
        print(stand.name)
        print(selectedStand.name)
    }
}
