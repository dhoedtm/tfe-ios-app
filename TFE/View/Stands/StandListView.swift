//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

struct StandListView: View {
    
    @EnvironmentObject private var vm : StandListViewModel
    
    @State var filePaths : [URL] = [URL]()
    @State var showAlert : Bool = false
    @State private var showDocumentPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                standList
                    .navigationTitle("Stands")
                    // .navigationBarTitleDisplayMode(.inline)
                uploadStand
            }
        }
    }
}

struct StandListView_Previews: PreviewProvider {
    static var previews: some View {
        StandListView()
            .environmentObject(StandListViewModel())
    }
}

// EXTENSION
// ---------

extension StandListView {
    private var standList: some View {
        List(vm.stands) { stand in
            NavigationLink(
                // selectedStand : stand
                destination: StandMapView()
                    .environmentObject(
                        TreesMapViewModel(selectedStand: stand)
                    )
            ) {
                Text("stand : \(stand.name)")
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
        }.padding(10)
    }
}
