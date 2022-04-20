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
                if (vm.isFetchingCaptures) {
                    ProgressView("Downloading captures...")
                } else if vm.captures.isEmpty {
                    Text("Tree has no capture to display")
                } else {
                    Text("Capture")
                        .font(.title3)
                        .bold()
                    CapturePicker(captures: vm.captures, selectedCapture: $vm.selectedCapture)
                    CaptureProperties(
                        capture: vm.selectedCapture,
                        diameters: vm.diameters,
                        isFetchingDiameter: vm.isFetchingDiameters
                    )
                    Divider()
                        .padding()
                    BarChart(title: "DBH history (meters)", data: vm.chartData)
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
                Badge(
                    type: .warning,
                    text: "Tree no longer exists as of \(DateParser.shortenDateString(dateString: deletedDate) ?? "date error")"
                )
            }
        }
    }
    
    @ViewBuilder var treeDetails : some View {
        HStack {
            LabelledText("longitude", String(vm.selectedTree.longitude))
            LabelledText("latitude", String(vm.selectedTree.latitude))
        }
        if let description = vm.selectedTree.treeDescription {
            LabelledText("description", !description.isEmpty ? description : "/")
        }
    }
}

private struct CapturePicker : View {
    
    let captures : [TreeCaptureEntity]
    @Binding var selectedCapture: TreeCaptureEntity?
    
    var body: some View {
        VStack {
            Picker("Capture date", selection: $selectedCapture) {
                ForEach(captures, id: \.self) { capture in
                    Text(
                        DateParser.formatDateString(dateString: capture.capturedAt ?? "") ?? "date error"
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
    var capture : TreeCaptureEntity?
    var diameters : [DiameterEntity]
    var isFetchingDiameter : Bool

    private let columns = [
        GridItem(.fixed(100)),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if let capture = capture {
                HStack {
                    LabelledText("dbh", capture.dbh.roundedToString(toPlaces: 3))
                    LabelledText("basal area", capture.basalArea.roundedToString(toPlaces: 3))
                }
                .padding(.bottom)
            }
            
            if (isFetchingDiameter) {
                ProgressView("Downloading diameters...")
            } else {
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
                        VStack {
                            ForEach(diameters, id: \.self) { diameter in
                                HStack {
                                    Text(diameter.height.roundedToString(toPlaces: 3))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(diameter.diameter.roundedToString(toPlaces: 3))
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

//struct TreeForm_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeCaptures()
//            .environmentObject(
//                TreeCapturesVM(selectedTree: MockData.trees.first!)
//            )
//    }
//}
