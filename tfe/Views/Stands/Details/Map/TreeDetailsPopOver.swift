//
//  TreeDetails.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct TreeDetailsPopOver: View {
    
    @EnvironmentObject var vm : StandMapVM
    @State private var showSheet : Bool = false
    
    @State private var id = ""
    @State private var idStand = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var description = ""
    
    var body: some View {
        if let tree = vm.selectedTree {
            VStack {
                HStack {
                    LabelledText("X", String(format: "%.5f", tree.latitude))
                    LabelledText("X", String(format: "%.5f", tree.longitude))
                    Button("More", action: { showSheet.toggle() })
                        .padding(7)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
                LabelledText("description", tree.description)
            }
            .sheet(isPresented: $showSheet, content: {
                TreeForm()
                    .environmentObject(
                        TreeFormVM(initialState: TreeFormState(tree: tree))
                    )
            })
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
        } else {
            Text("no tree being selected")
        }
    }
}

struct TreeDetails_Previews: PreviewProvider {
    @State static var treeToEdit = MockData.trees.first!
    static var previews: some View {
        TreeDetailsPopOver()
            .environmentObject(StandMapVM(selectedStand: MockData.stands.first!))
    }
}
