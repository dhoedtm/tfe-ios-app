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
            backButton
            form
            if vm.histories.isEmpty {
                Badge(
                    type: .warning,
                    text: "Stand has no histories to display")
            } else {
                Divider()
                    .padding()
                HistoryPicker(captures: vm.histories, selectedHistory: $vm.selectedHistory)
                HistoryProperties(history: vm.selectedHistory)
                Divider()
                    .padding()
                basalAreaChart
            }
        }
        .padding()
        .navigationBarHidden(true)
    }
}

private struct HistoryProperties : View {
    var history : StandHistoryModel

    private let columns = [
        GridItem(.fixed(100)),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("History").bold().padding(.top)
            Group {
//                Text("History").bold().padding(.top)
                LabelledText("treeCount", String(history.treeCount))
                LabelledText("basalArea", String(history.basalArea))
                LabelledText("meanDbh", String(history.meanDbh))
                LabelledText("meanDistance", String(history.meanDistance))
            }
            Group {
//                Text("History").bold().padding(.top)
                LabelledText("treeDensity", String(history.treeDensity))
                LabelledText("convexAreaMeter", String(history.convexAreaMeter))
                LabelledText("convexAreaHectare", String(history.convexAreaHectare))
                LabelledText("concaveAreaMeter", String(history.concaveAreaMeter))
                LabelledText("concaveAreaHectare", String(history.concaveAreaHectare))
            }
        }
    }
}

private struct HistoryPicker : View {
    
    let captures : [StandHistoryModel]
    @Binding var selectedHistory: StandHistoryModel
    
    var body: some View {
        Picker("Capture date", selection: $selectedHistory) {
            ForEach(captures, id: \.self) { capture in
                Text(
                    DateParser.formatDateString(dateString: capture.capturedAt) ?? "date error"
                ).tag(capture)
            }
        }
        .frame(height: 100)
        .clipped()
    }
}

extension StandDetailsView {
    
    var backButton: some View {
        BackButton() {
            HStack {
                Image(systemName: "arrowshape.turn.up.backward.circle")
                    .scaledToFit()
                    .scaleEffect(1.5)
                    .foregroundColor(.black)
                Spacer()
                Text("back to the stand list")
                    .fontWeight(.black)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 15)
            .cornerRadius(10)
        }
        .padding(.vertical, 5)
    }
    
    var form: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Stand").bold()
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
        BarChart(title: "Basal area history (meters)", data: getBasalAreas())
            .frame(height: UIScreen.main.bounds.height / 3)
    }
    
    func getBasalAreas() -> [ChartData] {
        return vm.histories.map { history in
            ChartData(
                label: DateParser.shortenDateString(dateString: history.capturedAt) ?? "date error",
                value: history.basalArea
            )
        }
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
