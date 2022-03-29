//
//  TreeForm.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct TreeForm: View {
    
    @EnvironmentObject var vm : TreeFormVM
    
    var body: some View {
        Form {
            Section(header: Text("General")) {
                TextField(
                    "Arbre malade, ...",
                    text: vm.binding(\.description)
                )
                if let error = vm.state.descriptionError {
                    Text(error)
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            Button(
                "Update",
                action: vm.updateTree
            )
            .disabled(!vm.state.isUpdateButtonEnabled)
        }
    }
}

struct TreeForm_Previews: PreviewProvider {
    static var previews: some View {
        TreeForm()
            .environmentObject(
                TreeFormVM(
                    initialState: TreeFormState(tree: MockData.trees.first!)
                )
            )
    }
}
