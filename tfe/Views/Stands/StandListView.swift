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
            if let error = vm.error {
                Badge(type: .error, text: error)
            }
            if(vm.isFetchingStands) {
                Spacer()
                ProgressView("Downloading stands...")
                Spacer()
            } else {
                standList
                    .navigationTitle("Stands")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        trailing:
                            Button(action: {
                                vm.reloadStandList()
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.green)
                            })
                    )
            }
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
                    destination: MasterView()
                        .environmentObject(MasterVM(selectedStand: stand))
                ) {
                    Text(stand.name)
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
                    // TODO: only reset selection when upload is succesful
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
