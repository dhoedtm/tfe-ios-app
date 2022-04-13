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
    @StateObject var locationManager = LocationManager.shared
    
    var body: some View {
        if (vm.isFetchingTrees) {
            loader
        } else {
            VStack {
                // body
                if vm.selectedTree == nil {
                    backButton
                    Spacer()
                    Text("There are no trees to display")
                    refreshButton
                    Spacer()
                } else {
                    ZStack {
                        treeMap
                        VStack {
                            header
                            Spacer()
                            treePopOver
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func createPopOver(tree: TreeModel) -> some View {
        let treeState = TreeFormState.init(tree: tree)
        let vm = TreeDetailsVM(initialState: treeState)
        return TreePopOver().environmentObject(vm)
    }
}

// MARK: EXTENSIONS

// in order to keep the main body of the view relatively short and thus readable,
// it is good practice to create extensions of that view

extension MapView {
    private var loader : some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView("Downloading trees...")
            HStack {
                Spacer()
                Button(
                    "Cancel",
                    action: vm.cancelTreesDownload
                )
                .buttonStyle(StandardButton())
                .scaledToFit()
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
}
extension MapView {
    private var backButton : some View {
        BackButton() {
            HStack {
                Image(systemName: "arrowshape.turn.up.backward.circle")
                    .scaledToFit()
                    .scaleEffect(1.5)
                    .foregroundColor(.black)
                Text("back to the stand list")
                    .accentColor(.black)
            }
        }
        .padding()
        .background(Color.green)
        .cornerRadius(10)
    }
}

extension MapView {
    private var refreshButton: some View {
        Button(action: {
            vm.reloadTrees()
        }, label: {
            Image(systemName: "arrow.clockwise")
                .scaledToFit()
                .scaleEffect(1.5)
                .foregroundColor(.green)
        })
        .padding()
    }
}

extension MapView {
    private var treeMap: some View {
        // "coordinateRegion" : for a set of long/lat points
        // could use "mapRect" to show zoom in on a specific area (e.g. stand bounding box)
        Map(
            coordinateRegion: $vm.selectedTreeRegion,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .none,
            annotationItems: vm.trees,
            annotationContent: { tree in
                MapAnnotation(coordinate: vm.getLocationFromCoordinates(tree: tree)) {
                    let isTreeSelected = vm.selectedTree == tree
                    let isTreeDeleted = tree.deletedAt != nil
                    VStack {
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
                        Text(String(tree.id))
                            .font(.caption2)
                            .accentColor(.black.opacity(0.7))
                    }
                }
            }
        )
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
            Button(action: {
                vm.reloadTrees()
            }, label: {
                Image(systemName: "arrow.clockwise")
                    .scaledToFit()
                    .scaleEffect(1.5)
                    .foregroundColor(.black)
            })
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
        .cornerRadius(10)
    }
}

extension MapView {
    // TODO: this is a hack since changing the vm.selectedTree property alone
    // wouldn't refresh the PopOver view and VM
    private var treePopOver: some View {
        ForEach(vm.trees, id: \.self) { tree in
            if (tree == vm.selectedTree) {
                createPopOver(tree: tree)
            }
        }
    }
}

// MARK: PREVIEW

struct StandMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapVM(selectedStand: MockData.stands.first!))
    }
}
