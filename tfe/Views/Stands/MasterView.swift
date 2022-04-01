//
//  StandMasterView.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import SwiftUI

struct MasterView: View {
    
    @EnvironmentObject private var vm : MasterVM
    
    var body: some View {
        TabView {
            MapView()
                .environmentObject(MapVM(selectedStand: vm.selectedStand))
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                            .resizable()
                            .foregroundColor(.green)
                        Text("Map")
                    }
                }
            StandDetailsView()
                .environmentObject(
                    StandDetailsVM(initialState: StandFormState(stand: vm.selectedStand))
                )
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .resizable()
                            .foregroundColor(.green)
                        Text("Details")
                    }
                }
        }
    }
}

struct StandMasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
            .environmentObject(MasterVM(selectedStand: MockData.stands.first!))
    }
}
