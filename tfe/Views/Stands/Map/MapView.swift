//
//  StandMapView.swift
//  TFE
//
//  Created by user on 22/02/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject private var vm : MapVM
    @Environment(\.presentationMode) var presentationMode
     
    var body: some View {
        Group {
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
                            .padding(.horizontal)
                        Spacer()
                        TreeDetailsPopOver()
                            .environmentObject(vm)
                            .padding()
                    }
                }
            }
        }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Return to sender") {
                    presentationMode.wrappedValue.dismiss() // this changes in iOS15
                }
            }
        }
    }
}

// MARK: EXTENSIONS

// in order to keep the main body of the view relatively short and thus readable,
// it is good practice to create extensions of that view

extension MapView {
    private var treeMap: some View {
        // "coordinateRegion" : for a set of long/lat points
        // could use "mapRect" to show zoom in on a specific area (a given stand bounding box)
        Map(
            coordinateRegion: $vm.selectedTreeRegion,
            annotationItems: vm.trees,
            annotationContent: { tree in
                MapAnnotation(coordinate: vm.getLocationFromCoordinates(tree: tree)) {
                    Image(systemName: "circle")
                        .resizable()
                        .foregroundColor(.green)
                        .scaledToFit()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.selectedTree = tree
                            }
                        }
                }
            }
        )
        // default safe area add padding to very top and bottom of the screen (curved areas)
        .ignoresSafeArea()
    }
}

extension MapView {
    private var header: some View {
        VStack {
            if let stand = vm.selectedStand {
                Text(DateParser.formatDateString(date: stand.captureDate) ?? "error displaying date")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .padding()
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
    static let vm : MapVM = {
        let vm = MapVM(selectedStand: MockData.stands.first!)
        // possible to tweak VM here :
        // e.g. fetching trees
        vm.errorList = ["SOMETHING BAD", "SONETHING WORSE"]
        return vm
    }()
    static var previews: some View {
        MapView()
            .environmentObject(vm)
    }
}
