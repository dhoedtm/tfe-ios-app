//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

struct StandListView: View {
    
    @EnvironmentObject private var vm : StandListVM
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: StandEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \StandEntity.name, ascending: false)
        ]
    ) var stands: FetchedResults<StandEntity>
    
    @State var filePaths : [URL] = [URL]()
    @State var showAlert : Bool = false
    @State private var showDocumentPicker = false
    
    var body: some View {
        VStack {
            if(vm.isFetchingStands) {
                loader
            } else {
                standList
                    .navigationTitle("Stands")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                vm.syncWithApi()
                            }, label: {
                                Image(systemName: "icloud.and.arrow.down")
                                    .foregroundColor(.green)
                            }),
                        trailing:
                            Button(action: {
                                vm.reloadStandList()
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.green)
                            })
                    )
                uploadList
            }
            Spacer()
            uploadStand
        }
    }
}

// MARK: EXTENSIONS

extension StandListView {
    private var loader : some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView("Downloading stands...")
            HStack {
                Spacer()
                Button(
                    "Cancel",
                    action: vm.cancelStandDownload
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

extension StandListView {
    private var standList: some View {
        List {
            ForEach(stands, id: \.id) { stand in
                NavigationLink(
                    destination: StandMasterView()
                        .environmentObject(StandMasterVM(selectedStand: stand))
                ) {
                    Text(stand.name ?? "")
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        vm.deleteStand(offsets: offsets)
    }
}

extension StandListView {
    private var uploadList : some View {
        VStack {
            ForEach(vm.cancellableUploads, id: \.self) { item in
                Button(action: item.cancellable.cancel, label: {
                    HStack {
                        Image(systemName: "icloud.and.arrow.up")
                        Text("cancel : \(item.label)")
                    }
                })
            }
        }
    }
}

extension StandListView {
    private var uploadStand: some View {
        HStack {
            Button(action: {
                showDocumentPicker = true
            }, label: {
                Text("Select pointcloud")
                    .frame(maxWidth: .infinity)
            })
            .sheet(isPresented: self.$showDocumentPicker) {
                DocumentPicker(filePaths: $filePaths)
            }
            .buttonStyle(StandardButton())
            
            Button(action: {
                if (filePaths.isEmpty) {
                    showAlert = true
                } else {
                    vm.uploadPointClouds(filePaths: filePaths)
                    // TODO: only reset selection when upload is successful
                    filePaths = [URL]()
                }
            }, label: {
                Text("Upload")
                    .frame(maxWidth: .infinity)
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
            .buttonStyle(StandardButton())
        }
        .padding()
    }
}

// MARK: PREVIEW

struct StandListView_Previews: PreviewProvider {
    static var previews: some View {
        StandListView()
            .environmentObject(StandListVM())
    }
}
