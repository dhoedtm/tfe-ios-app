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
                .tabItem {
                    Text("Map")
                }
            StandDetailsView()
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
