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
                        VStack {
                            HStack {
                                header
                            }
                            Spacer()
                            ForEach(vm.trees, id: \.self) { tree in
                                if (tree == vm.selectedTree) {
                                    createPopOver(tree: tree)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func createPopOver(tree: TreeModel) -> some View {
        return
            TreePopOver()
                .environmentObject(
                    TreeDetailsVM(initialState:
                                    TreeFormState.init(tree: tree))
                )
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
                        .scaleEffect()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.selectedTree = tree
                            }
                        }
                        .onLongPressGesture(
                            minimumDuration: 1,
                            perform: {
                                vm.deleteTree(idTree: tree.id)
                            }
                        )
                }
            }
        )
        // default safe area add padding to very top and bottom of the screen (curved areas)
        .ignoresSafeArea()
    }
}

extension MapView {
    private var header: some View {
        HStack {
            BackButton() {
                Image(systemName: "arrowshape.turn.up.backward.circle")
                    .scaledToFit()
                    .scaleEffect(1.5)
                    .foregroundColor(.black)
            }
            Spacer()
            if let stand = vm.selectedStand {
                Text(DateParser.formatDateString(dateString: stand.capturedAt) ?? "error displaying date")
                    .font(.title2)
                    .fontWeight(.black)
            } else {
                Text("no stand could be found")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
        .cornerRadius(10)
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
