//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

struct StandListView: View {
    
    @EnvironmentObject private var vm : StandListVM
    
    @State var filePaths : [URL] = [URL]()
    @State var showAlert : Bool = false
    @State private var showDocumentPicker = false
    
    var body: some View {
        VStack {
            standList
                .navigationTitle("Stands")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading:
                        Image(systemName: "icloud.and.arrow.down")
                            .foregroundColor(.green)
                            .onTapGesture {
                                vm.syncWithApi(isHardSync: false)
                            }
                            .onLongPressGesture(
                                minimumDuration: 2,
                                perform: {
                                    vm.syncWithApi(isHardSync: true)
                                }
                            )
                )
            uploadList
            Spacer()
            uploadStand
        }
    }
}

// MARK: EXTENSIONS

extension StandListView {
    private var standList: some View {
        List {
            ForEach(vm.stands, id: \.id) { stand in
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
            ForEach(vm.cancellableUploads, id: \.id) { item in
                Button(action: { vm.cancelUpload(fileURL: item.id) }, label: {
                    HStack {
                        Image(systemName: "xmark")
                        HStack {
                            let action = item.action.rawValue
                            if let progress = item.progress {
                                Text("\(action) [\((progress * 100).roundedToString(toPlaces: 1))] :")
                            } else {
                                Text("\(action) :")
                            }
                            Text(item.fileName)
                                .lineLimit(1)
                                .truncationMode(.head)
                        }
                    }
                })
                .buttonStyle(StandardButton())
                .padding(5)
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
