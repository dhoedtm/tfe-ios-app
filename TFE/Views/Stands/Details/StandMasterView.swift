//
//  StandMasterView.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import SwiftUI

struct StandMasterView: View {
    
    @EnvironmentObject private var vm : StandMasterVM
    
    var body: some View {
        TabView {
            StandMapView()
                .environmentObject(StandMapVM(selectedStand: vm.selectedStand))
                .tabItem {
                    Text("Map")
                }
            Text("B")
                .tabItem {
                    Text("Details")
                }
        }
    }
}

struct StandMasterView_Previews: PreviewProvider {
    static var previews: some View {
        StandMasterView()
    }
}
