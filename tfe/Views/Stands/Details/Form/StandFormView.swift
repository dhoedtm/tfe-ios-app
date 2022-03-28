//
//  StandFormView.swift
//  fix
//
//  Created by martin d'hoedt on 3/27/22.
//

import SwiftUI

struct StandFormView: View {
    
    @EnvironmentObject private var vm : StandFormVM
    
    @State private var id : String = ""
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var treeCount : String = ""
    @State private var basalArea : String = ""
    @State private var treeDensity : String = ""
    @State private var meanDbh : String = ""
    @State private var meanDistance : String = ""
    @State private var convexAreaMeter : String = ""
    @State private var convexAreaHectare : String = ""
    @State private var concaveAreaMeter : String = ""
    @State private var concaveAreaHectare : String = ""
    
    var body: some View {
        VStack {
            captureDatePicker
                .padding()
            form
//                Divider()
//                LineChart()
            Button("Update", action: update)
                .padding()
            Group {
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
                Text("COUCOU")
            }
        }
    }
}

extension StandFormView {
    var captureDatePicker: some View {
        Text("CAPTURE DATE PICKER")
    }
    
    var form: some View {
        Form {
            Section(header: Text("General")) {
                LabelledTextField("id", $id, isDisabled: true)
                LabelledTextField("name", $name, isDisabled: false)
                LabelledTextField("description", $description, isDisabled: false)
            }
            Section(header: Text("Metrics")) {
                LabelledTextField("treeCount", $treeCount, isDisabled: true)
                LabelledTextField("basalArea", $basalArea, isDisabled: true)
                LabelledTextField("minDbh", $meanDbh, isDisabled: true)
                LabelledTextField("minDistance", $meanDistance, isDisabled: true)
            }
            Section(header: Text("Areas")) {
                LabelledTextField("convexAreaMeter", $convexAreaMeter, isDisabled: true)
                LabelledTextField("convexAreaHectare", $convexAreaHectare, isDisabled: true)
                LabelledTextField("concaveAreaMeter", $concaveAreaMeter, isDisabled: true)
                LabelledTextField("concaveAreaHectare", $concaveAreaHectare, isDisabled: true)
            }
        }
        .onAppear(perform: populate)
    }
    
    func populate() {
        id = String(vm.selectedStand.id)
        name = String(vm.selectedStand.name)
        description = vm.selectedStand.description
        treeCount = String(vm.selectedStand.treeCount)
        basalArea = String(vm.selectedStand.basalArea)
        treeDensity = String(vm.selectedStand.treeDensity)
        meanDbh = String(vm.selectedStand.meanDbh)
        meanDistance = String(vm.selectedStand.meanDistance)
        convexAreaMeter = String(vm.selectedStand.convexAreaMeter)
        convexAreaHectare = String(vm.selectedStand.convexAreaHectare)
        concaveAreaMeter = String(vm.selectedStand.concaveAreaMeter)
        concaveAreaHectare = String(vm.selectedStand.concaveAreaHectare)
    }
    
    func update() {
        // since the model is a struct, it creates a copy (leaves selectedStand intact)
        var stand = vm.selectedStand
        // TODO: check if valid changes
        stand.name = name
        stand.description = description
        vm.updateStand(stand: stand)
    }
}

//struct StandFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        StandFormView()
//    }
//}
