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
        ScrollView {
            form
            Divider()
                .padding()
            dbhChart
        }
        .padding()
    }
}

extension TreeForm {
    private var form: some View {
        Group {
            Text("General").bold().padding(.top)
            LabelledTextEditor("description", vm.binding(\.description), isDisabled: false)
            if let error = vm.state.descriptionError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Button(
                "Update",
                action: vm.updateTree
            )
            .buttonStyle(StandardButton())
            .disabled(!vm.state.isUpdateButtonEnabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dbhChart: some View {
        VStack {
            Text("DBH")
                .bold()
            LineChart(data: MockData.dbhList)
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
