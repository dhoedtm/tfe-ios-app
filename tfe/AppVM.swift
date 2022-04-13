//
//  AppVM.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//

import Foundation

class AppVM : ObservableObject {
    
    // services
    let dataStore = InMemoryDataStore.shared
    
    // ui
    var isLocalDataFetching = false
    
    init() {
//        isLocalDataFetching = true
//        dataStore
//            .fetchAll()
    }
}
