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
                    VStack {
                        Image(systemName: "map")
                            .resizable()
                            .foregroundColor(.green)
                        Text("Map")
                    }
                }
            StandDetailsView()
                .environmentObject(
                    StandDetailsVM(initialState: StandFormState(standEntity: vm.selectedStand))
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

//struct StandMasterView_Previews: PreviewProvider {
//    static var previews: some View {
//        StandMasterView()
//            .environmentObject(StandMasterVM(selectedStand: MockData.stands.first!))
//    }
//}
