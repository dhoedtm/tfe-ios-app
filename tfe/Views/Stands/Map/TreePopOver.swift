//
//  TreeDetails.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct TreePopOver: View {
    
    @EnvironmentObject var vm : TreeDetailsVM
    @State private var showSheet : Bool = false
        
    var body: some View {
        form
            .sheet(isPresented: $showSheet, content: {
                TreeCaptures()
                    .environmentObject(
                        TreeCapturesVM(selectedTree: vm.selectedTree)
                    )
            })
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

extension TreePopOver {
    private var form : some View {
        VStack {
            HStack {
                HStack {
                    LabelledTextField(
                        "latitude",
                        $vm.latitude,
                        isDisabled: true)
                    LabelledTextField(
                        "longitude",
                        $vm.longitude,
                        isDisabled: true)
                }
                VStack {
                    LabelledTextField(
                        "description",
                        $vm.description,
                        isDisabled: false)
                    if let error = vm.descriptionError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            HStack {
                Button("More", action: { showSheet.toggle() })
                    .buttonStyle(StandardButton())
                if vm.isUpdating {
                    Button(
                        "Cancel",
                        action: vm.cancelUpdate    
                    )
                    .buttonStyle(StandardButton())
                } else {
                    Button(
                        "Update",
                        action: vm.updateTreeDetails
                    )
                    .buttonStyle(StandardButton())
                    .disabled(!vm.isUpdateButtonEnabled)
                }
            }
        }
        .animation(.none)
    }
}

//struct TreeDetails_Previews: PreviewProvider {
//    @State static var treeToEdit = MockData.trees.first!
//    static var previews: some View {
//        TreePopOver()
//            .environmentObject(
//                TreeDetailsVM(initialState:
//                                TreeFormState.init(treeModel: MockData.trees.first!))
//            )
//    }
//}
