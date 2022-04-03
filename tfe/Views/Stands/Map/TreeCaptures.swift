//
//  TreeForm.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import SwiftUI

struct TreeCaptures: View {
    
    @EnvironmentObject var vm : TreeCapturesVM
    @State var selectedCapture : TreeCaptureModel? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if selectedCapture == nil {
                Text("Tree has no capture to display")
            } else {
                CapturePicker(captures: vm.captures, selectedCapture: $selectedCapture)
            }
            treeDetails
                .padding(.bottom, 2)
            if let capture = selectedCapture {
                CaptureProperties(capture: capture, diameters: vm.diameters)
                Divider()
                    .padding()
                BarChart(title: "DBH history (meters)", data: MockData.chartData)
                    .frame(height: UIScreen.main.bounds.height / 3)
            }
        }
        .padding()
        .onAppear {
            selectedCapture = vm.captures.first ?? nil
        }
    }
}

extension TreeCaptures {
    @ViewBuilder var treeDetails : some View {
        HStack {
            LabelledText("longitude", String(vm.selectedTree.longitude))
            LabelledText("latitude", String(vm.selectedTree.latitude))
        }
        if let description = vm.selectedTree.description {
            LabelledText("description", !description.isEmpty ? description : "/")
        }
    }
}

private struct CapturePicker : View {
    
    let captures : [TreeCaptureModel]
    @Binding var selectedCapture: TreeCaptureModel?
    
    var body: some View {
        Picker("Capture date", selection: $selectedCapture) {
            ForEach(captures, id: \.self) { capture in
                Text(
                    DateParser.formatDateString(date: capture.capturedAt) ?? "date error"
                ).tag(capture)
            }
        }
        .frame(height: 100)
        .clipped()
    }
}

struct CaptureProperties : View {
    var capture : TreeCaptureModel
    var diameters : [DiameterModel]

    private let columns = [
        GridItem(.fixed(100)),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LabelledText("dbh", String(capture.dbh))
                LabelledText("basal area", String(capture.dbh))
            }
            .padding(.bottom)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Height :")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Diameter :")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        ScrollView {
                            ForEach(diameters, id: \.self) { diameter in
                                HStack {
                                    Text(String(diameter.height.rounded(toPlaces: 3)))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(diameter.diameter.rounded(toPlaces: 3)))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct TreeForm_Previews: PreviewProvider {
    static var previews: some View {
        TreeCaptures()
            .environmentObject(
                TreeCapturesVM(
                    selectedTree: MockData.trees.first!,
                    captures: MockData.captures,
                    diameters: MockData.diameters
                )
            )
    }
}
