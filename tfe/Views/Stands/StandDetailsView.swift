//
//  StandFormView.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import SwiftUI

struct StandDetailsView: View {
    
    @EnvironmentObject private var vm : StandDetailsVM
    
    var body: some View {
        ScrollView {
            if vm.histories.isEmpty {
                Text("Stand has no history")
            } else if let histories = vm.histories {
                HistoryPicker(captures: histories, selectedHistory: $vm.selectedHistory)
            }
            form
            Divider()
                .padding()
            basalAreaChart
        }
        .padding()
    }
}

private struct HistoryPicker : View {
    
    let captures : [StandHistoryModel]
    @Binding var selectedHistory: StandHistoryModel
    
    var body: some View {
        Picker("Capture date", selection: $selectedHistory) {
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

extension StandDetailsView {
    
    var form: some View {
        VStack(alignment: .leading) {
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
    }
    
    var basalAreaChart : some View {
        BarChart(title: "Basal area history (meters)", data: MockData.chartData)
            .frame(height: UIScreen.main.bounds.height / 3)
    }
}

struct StandFormView_Previews: PreviewProvider {
    static var previews: some View {
        StandDetailsView()
            .environmentObject(
                StandDetailsVM(initialState: StandFormState(stand: MockData.stands.first!))
            )
    }
}
