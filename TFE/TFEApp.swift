//
//  TFEApp.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI
import Swinject

let container : Container = {
    let container = Container()
    container.register(APIManaging.self) { _ in
        return MockAPIManager()
    }
    return container
}()

@main
struct TFEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
