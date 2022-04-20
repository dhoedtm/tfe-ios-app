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
    @StateObject var locationManager = LocationManager.shared
    
    @State var filePaths : [URL] = [URL]()
    @State var showAlert : Bool = false
    @State private var showDocumentPicker = false
    
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
    
    func createPopOver(tree: TreeEntity) -> some View {
        let vm = TreeDetailsVM(selectedTree: vm.selectedTree!)
        return TreePopOver().environmentObject(vm)
    }
}

// MARK: LOADER

extension StandMapView {
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

// MARK: BACK BUTTON

extension StandMapView {
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

// MARK: REFRESH BUTTON

extension StandMapView {
    private var refreshButton: some View {
        Button(action: {
            vm.updateTrees()
        }, label: {
            Image(systemName: "arrow.clockwise")
                .scaledToFit()
                .scaleEffect(1.5)
                .foregroundColor(.green)
        })
        .padding()
    }
}

// MARK: TREE MAP

extension StandMapView {
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

// MARK: HEADER

extension StandMapView {
    private var header: some View {
        HStack {
            header_backButton
            Spacer()
            header_date
            Spacer()
            VStack {
                header_updateStandFilePicker
                    .padding(.top, 5)
                header_updateStandSubmit
                    .padding(.horizontal, 5)
                header_fetchRemoteTrees
                    .padding(.bottom, 5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
        .cornerRadius(10)
    }
}

extension StandMapView {
    private var header_backButton: some View {
        BackButton() {
            Image(systemName: "arrowshape.turn.up.backward.circle")
                .scaledToFit()
                .scaleEffect(1.5)
                .foregroundColor(.black)
        }
    }
}
extension StandMapView {
    private var header_date: some View {
        Text(DateParser.formatDateString(dateString: vm.selectedStand.capturedAt ?? "") ?? "error displaying date")
            .font(.title2)
            .fontWeight(.black)
    }
}
extension StandMapView {
    private var header_fetchRemoteTrees: some View {
        Button(action: {
            vm.updateTrees()
        }, label: {
            Image(systemName: "arrow.clockwise")
                .scaledToFit()
                .foregroundColor(.black)
        })
    }
}
extension StandMapView {
    private var header_updateStandFilePicker: some View {
        Button(action: {
            showDocumentPicker = true
        }, label: {
            Image(systemName: "folder")
                .scaledToFit()
                .foregroundColor(.black)
        })
        .sheet(isPresented: self.$showDocumentPicker) {
            DocumentPicker(filePaths: $filePaths)
        }
    }
}
extension StandMapView {
    private var header_updateStandSubmit: some View {
        Button(action: {
            if (filePaths.isEmpty) {
                showAlert = true
            } else {
                vm.uploadPointClouds(filePaths: filePaths)
                // TODO: only reset selection when upload is successful
                filePaths = [URL]()
            }
        }, label: {
            Image(systemName: "icloud.and.arrow.up")
                .scaledToFit()
                .foregroundColor(.black)
        })
        .alert(
            isPresented: $showAlert,
            content: {
                Alert(
                    title: Text("Upload error"),
                    message: Text("please select a pointcloud before uploading")
                )
            }
        )
    }
}

// MARK: POP OVER

extension StandMapView {
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

//struct StandMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        StandMapView()
//            .environmentObject(StandMapVM(selectedStand: MockData.stands.first!))
//    }
//}
