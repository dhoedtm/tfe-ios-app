//
//  TreeForm.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct TreeCaptures: View {
    
    @EnvironmentObject var vm : TreeCapturesVM
    
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

extension TreeCaptures {
    private var form: some View {
        VStack(alignment: .leading) {
            Text("General").bold().padding(.top)
            LabelledText("description", "....")
        }
    }
    
    private var dbhChart: some View {
        BarChart(title: "DBH history (meters)", data: MockData.chartData)
            .frame(height: UIScreen.main.bounds.height / 3)
    }
}

struct TreeForm_Previews: PreviewProvider {
    static var previews: some View {
        TreeCaptures()
            .environmentObject(
                TreeCapturesVM(selectedTree: MockData.trees.first!)
            )
    }
}
