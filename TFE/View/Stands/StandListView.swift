//
//  StandListView.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI



struct StandListView: View {
    var body: some View {
        List(stands) { stand in
            Text("Coucou from : \(stand.name)")
        }
    }
}

struct StandListView_Previews: PreviewProvider {
    static var previews: some View {
        StandListView()
    }
}
