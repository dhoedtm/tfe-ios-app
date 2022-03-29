//
//  StandMapView.swift
//  TFE
//
//  Created by user on 22/02/2022.
//

import SwiftUI
import MapKit

struct StandMapView: View {
    
    @EnvironmentObject private var vm : StandMapVM
    
    var body: some View {
        ZStack {
            if let error = vm.error { Text(error) }
            if (vm.isFetchingTrees) { ProgressView() } else {
                if (vm.trees.isEmpty) {
                    Text("stand is empty, no trees could be found")
                        .bold()
                } else {
                    treeMap
                    VStack(spacing:0) {
                        header
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: EXTENSIONS

// in order to keep the main body of the view relatively short and thus readable,
// it is good practice to create extensions of that view

extension StandMapView {
    private var treeMap: some View {
        // "coordinateRegion" : for a set of long/lat points
        // could use "mapRect" to show zoom in on a specific area (a given stand bounding box)
        Map(
            coordinateRegion: $vm.selectedTreeRegion,
            annotationItems: vm.trees,
            annotationContent: { tree in
                MapAnnotation(coordinate: vm.getLocationFromCoordinates(tree: tree)) {
                    Image(systemName: "map.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .background(Color.green)
                        .foregroundColor(.green)
                }
            }
        )
            // default safe area add padding to very top and bottom of the screen (curved areas)
            .ignoresSafeArea()
    }
}

extension StandMapView {
    private var header: some View {
        VStack {
            if let stand = vm.selectedStand {
                Text(DateParser.formatDateString(date: stand.captureDate) ?? "error displaying date")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                .frame(maxWidth: .infinity)
            } else {
                Text("no stand could be found")
            }
        }
        .background(Color.gray)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
    }
}

// MARK: PREVIEW

struct StandMapView_Previews: PreviewProvider {
    static let vm : StandMapVM = {
        let vm = StandMapVM(selectedStand: MockData.stands.first!)
        vm.isFetchingTrees = false
        return vm
    }()
    static var previews: some View {
        StandMapView()
            .environmentObject(vm)
    }
}
