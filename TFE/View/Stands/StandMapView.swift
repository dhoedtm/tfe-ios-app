//
//  StandMapView.swift
//  TFE
//
//  Created by user on 22/02/2022.
//

import SwiftUI
import MapKit

struct StandMapView: View {
    
    @EnvironmentObject private var vm : StandListViewModel
    
    var body: some View {
        ZStack {
            // "coordinateRegion" : for a set of long/lat points
            // could use "mapRect" to show zoom in on a specific area (a given stand bounding box)
            Map(coordinateRegion: $vm.selectedStandRegion)
                // default safe area add padding to very top and bottom of the screen (curved areas)
                .ignoresSafeArea()
            
            VStack(spacing:0) {
                header
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct StandMapView_Previews: PreviewProvider {
    static var previews: some View {
        StandMapView()
    }
}

// in order to keep the main body of the view relatively short and thus readable,
// it is good practice to create extensions of that view
extension StandMapView {
    private var header: some View {
        VStack {
            Text(vm.selectedStand.name)
                .font(.title2)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .frame(height: 55)
            .frame(maxWidth: .infinity)
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}
