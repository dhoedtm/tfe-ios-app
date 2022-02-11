//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

struct StandListView: View {
    
    //
    @EnvironmentObject private var vm : StandListViewModel
    
    var body: some View {
        List(vm.stands) { stand in
            Text("Coucou from : \(stand.name)")
        }
    }
}

struct StandListView_Previews: PreviewProvider {
    static var previews: some View {
        StandListView()
            .environmentObject(StandListViewModel())
    }
}
