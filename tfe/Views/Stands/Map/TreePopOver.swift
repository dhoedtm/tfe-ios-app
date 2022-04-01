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
    
    init() {
        print("------------------- POP OVER")
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    LabelledTextField("latitude", vm.binding(\.latitude), isDisabled: true) // String(format: "%.5f", vm.state.latitude)
                    LabelledTextField("longitude", vm.binding(\.longitude), isDisabled: true)
                }
                VStack {
                    LabelledTextField("description", vm.binding(\.description), isDisabled: false)
                    if let error = vm.state.descriptionError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            HStack {
                Button("More", action: { showSheet.toggle() })
                    .buttonStyle(StandardButton())
                Button(
                    "Update",
                    action: vm.updateTree
                )
                .buttonStyle(StandardButton())
                .disabled(!vm.state.isUpdateButtonEnabled)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            TreeCaptures()
                .environmentObject(
                    TreeCapturesVM(selectedTree: TreeModel(treeFormState: vm.state))
                )
        })
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onAppear {
            print("\(vm.state.id)")
        }
    }
}

struct TreeDetails_Previews: PreviewProvider {
    @State static var treeToEdit = MockData.trees.first!
    static var previews: some View {
        TreePopOver()
            .environmentObject(MapVM(selectedStand: MockData.stands.first!))
    }
}
