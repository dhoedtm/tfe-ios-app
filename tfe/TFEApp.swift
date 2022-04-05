//
//  TFEApp.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

// TODO: move init DI inside constructor
// Create Mock and Prod DI setups in separate classes
//let container : Container = {
//    // "let" creates a constant, cannot change after initialization
//    // use of a closure to build and initialize the outer container
//    let container = Container()
//    // uses a closure with unused variabe _ in case we would want to tweak the instance
//    // before completing its registration
//    container.register(APIManaging.self) { _ in return MockAPIManager() }
//    return container
//}()

// replaces "AppDelegate" and "SceneDelegate" used in older SwiftUI version (<2.0)
// it is the starting point of the application
@main
struct TFEApp: App {
    
    // VMs can be replaced with mocks for testing purposes
    // TODO: consider using Swinject also for this kind of DI (not only services)
    @StateObject private var standListVM = StandListVM()
    
    // init() {}
    
    var body: some Scene {
        // WindowGroup is used to hold potentially multiple windows that the user opens
        // throughout the use of the application
        WindowGroup {
            NavigationView {
                StandListView()
                    .environmentObject(standListVM)
//                    .navigationBarHidden(true)
            }
        }
    }
}
