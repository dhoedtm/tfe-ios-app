//
//  TFEApp.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI
import Swinject

// Dependency Injection - initialization
let container : Container = {
    // "let" creates a constant, cannot change after initialization
    // use of a closure to build and initialize the outer container
    let container = Container()
    // uses a closure with unused variabe _ in case we would want to tweak the instance
    // before completing its registration
    container.register(APIManaging.self) { _ in return MockAPIManager() }
    return container
}()

@main
struct TFEApp: App {
    var body: some Scene {
        WindowGroup {
            StandListView()
        }
    }
}
