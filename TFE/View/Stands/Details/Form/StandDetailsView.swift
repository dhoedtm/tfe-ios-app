//
//  StandDetailsView.swift
//  TFE
//
//  Created by martin d'hoedt on 3/24/22.
//

import SwiftUI

struct StandDetailsView: View {
    
    @EnvironmentObject private var vm : StandDetailsVM
    
    var body: some View {
        VStack {
            Group {
                TextField(vm.selectedStand.name)
                TextField(vm.selectedStand.description)
            }
            Text(vm.selectedStand.captureDate)
            Group {
                Text(vm.selectedStand.convexAreaMeter)
                Text(vm.selectedStand.convexAreaHectare)
                Text(vm.selectedStand.concaveAreaMeter)
                Text(vm.selectedStand.concaveAreaHectare)
            }
            Group {
                Text(vm.selectedStand.treeCount)
                Text(vm.selectedStand.basalArea)
                Text(vm.selectedStand.treeDensity)
                Text(vm.selectedStand.meanDbh)
                Text(vm.selectedStand.meanDistance)
            }
            HStack {
                Button("Update stand details", vm.updateStandDetails())
                Button("Update stand details", )
            }
        }
    }
}

struct StandDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StandDetailsView()
    }
}
