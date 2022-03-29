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
        if (vm.isFetchingTrees) {
            ProgressView()
        } else {
            VStack {
                // errors
                ForEach(vm.errorList, id: \.self) {
                    Text($0)
                }
                // body
                ZStack {
                    treeMap
                    VStack() {
                        header
                            .padding()
                        Spacer()
                        TreeDetailsPopOver()
                            .environmentObject(vm)
                            .padding()
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
                        .onTapGesture {
                            vm.selectedTree = tree
                        }
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
    }
}

// MARK: PREVIEW

struct StandMapView_Previews: PreviewProvider {
    static let vm : StandMapVM = {
        let vm = StandMapVM(selectedStand: MockData.stands.first!)
        // possible to tweak VM here :
        // e.g. fetching trees
        vm.errorList = ["SOMETHING BAD", "SONETHING WORSE"]
        return vm
    }()
    static var previews: some View {
        StandMapView()
            .environmentObject(vm)
    }
}
