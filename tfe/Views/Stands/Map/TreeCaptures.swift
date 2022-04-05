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
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                treeDeletedWarning
                    .padding(.bottom)
                treeDetails
                    .padding(.bottom, 2)
                if vm.captures.isEmpty {
                    Text("Tree has no capture to display")
                } else {
                    Text("Capture")
                        .font(.title3)
                        .bold()
                    CapturePicker(captures: vm.captures, selectedCapture: $vm.selectedCapture)
                    CaptureProperties(capture: vm.selectedCapture, diameters: vm.diameters)
                    Divider()
                        .padding()
                    BarChart(title: "DBH history (meters)", data: MockData.chartData)
                        .frame(height: UIScreen.main.bounds.height / 3)
                }
            }
        }
        .padding()
    }
}

extension TreeCaptures {
    @ViewBuilder var treeDeletedWarning : some View {
        if let deletedDate = vm.selectedTree.deletedAt {
            if !deletedDate.isEmpty {
                Text("Tree no longer exists as of \(DateParser.shortenDateString(dateString: deletedDate) ?? "date error")")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
    
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
    @Binding var selectedCapture: TreeCaptureModel
    
    var body: some View {
        VStack {
            Picker("Capture date", selection: $selectedCapture) {
                ForEach(captures, id: \.self) { capture in
                    Text(
                        DateParser.formatDateString(dateString: capture.capturedAt) ?? "date error"
                    )
                    .font(.body)
                    .tag(capture)
                }
            }
            .frame(height: 80)
            .clipped()
        }
    }
}

private struct CaptureProperties : View {
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
//                    ZStack {
                        VStack {
                            ForEach(diameters, id: \.self) { diameter in
                                HStack {
                                    Text(String(diameter.height.rounded(toPlaces: 3)))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(diameter.diameter.rounded(toPlaces: 3)))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
//                        HStack {
//                            Spacer()
//                            VStack {
//                                Image(systemName: "arrowtriangle.up.fill")
//                                    .font(.caption)
//                                Spacer()
//                                Image(systemName: "arrowtriangle.down.fill")
//                                    .font(.caption)
//                            }
//                            .opacity(0.5)
//                        }
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
