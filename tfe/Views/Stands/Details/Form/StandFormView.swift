//
//  StandFormView.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import SwiftUI

struct StandFormView: View {
    
    @EnvironmentObject private var vm : StandFormVM
    
    var body: some View {
        ScrollView {
            captureDatePicker
            form
            Divider()
                .padding()
            basalAreaChart
        }
        .padding()
    }
}

extension StandFormView {
    var captureDatePicker: some View {
        Text("STAND CAPTURE DATE PICKER")
    }
    
    var form: some View {
        Group {
            Group {
                Text("General").bold().padding(.top)
                LabelledTextField("id", vm.binding(\.id), isDisabled: true)
                LabelledTextField("name", vm.binding(\.name), isDisabled: false)
                if let error = vm.state.nameError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                LabelledTextField("description", vm.binding(\.description), isDisabled: false)
                if let error = vm.state.descriptionError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            Group {
                Text("Metrics").bold().padding(.top)
                LabelledTextField("treeCount", vm.binding(\.treeCount), isDisabled: true)
                LabelledTextField("basalArea", vm.binding(\.basalArea), isDisabled: true)
                LabelledTextField("minDbh", vm.binding(\.meanDbh), isDisabled: true)
                LabelledTextField("minDistance", vm.binding(\.meanDistance), isDisabled: true)
            }
            Group {
                Text("Areas").bold().padding(.top)
                LabelledTextField("convexAreaMeter", vm.binding(\.convexAreaMeter), isDisabled: true)
                LabelledTextField("convexAreaHectare", vm.binding(\.convexAreaHectare), isDisabled: true)
                LabelledTextField("concaveAreaMeter", vm.binding(\.concaveAreaMeter), isDisabled: true)
                LabelledTextField("concaveAreaHectare", vm.binding(\.concaveAreaHectare), isDisabled: true)
            }
            Button(
                "Update",
                action: vm.updateStand
            )
            .buttonStyle(StandardButton())
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(!vm.state.isUpdateButtonEnabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var basalAreaChart : some View {
        BarChart(title: "Basal area", legend: "meters", barColor: .green, data: MockData.chartData)
            .frame(height: UIScreen.main.bounds.height / 3)
            .padding()
    }
}

struct StandFormView_Previews: PreviewProvider {
    static var previews: some View {
        StandFormView()
            .environmentObject(
                StandFormVM(initialState: StandFormState(stand: MockData.stands.first!))
            )
    }
}
