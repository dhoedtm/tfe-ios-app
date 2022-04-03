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
                if vm.selectedTree == nil {
                    Text("There are no trees to display")
                } else {
                    ZStack {
                        treeMap
                        VStack() {
                            header
                                .padding(.horizontal)
                            Spacer()
                            ForEach(vm.trees, id: \.self) { tree in
                                if (tree == vm.selectedTree) {
                                    createPopOver(tree: tree)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createPopOver(tree: TreeModel) -> some View {
        return
            TreePopOver()
                .environmentObject(
                    TreeDetailsVM(initialState:
                                    TreeFormState.init(tree: tree))
                )
                .padding()
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
                    let isTreeSelected = vm.selectedTree == tree
                    let isTreeDeleted = tree.deletedAt != nil
                    Image(systemName: isTreeSelected ? "circle.fill" : "circle")
                        .resizable()
                        .foregroundColor(isTreeDeleted ? .red : .green)
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
                Text(DateParser.formatDateString(date: stand.capturedAt) ?? "error displaying date")
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
