//
//  TFEApp.swift
//  TFE
//
//  Created by user on 02/02/2022.
//

import SwiftUI

@main
struct TFEApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
