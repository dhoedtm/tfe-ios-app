//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

struct StandListView: View {
    
    @EnvironmentObject private var vm : StandListViewModel
    
    var body: some View {
        NavigationView {
            List(vm.stands) { stand in
                NavigationLink(
                    // selectedStand : stand
                    destination: StandMapView()
                        .environmentObject(
                            TreesMapViewModel(selectedStand: stand)
                        )
                ) {
                    Text("stand : \(stand.name)")
                }
            }
            .navigationTitle("Stands")
            // .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StandListView_Previews: PreviewProvider {
    static var previews: some View {
        StandListView()
            .environmentObject(StandListViewModel())
    }
}
