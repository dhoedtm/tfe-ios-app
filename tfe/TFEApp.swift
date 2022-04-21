//
//  TFEApp.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import SwiftUI

// TODO :
// - Use DI lib (e.g. Swinject)
// - create Mock and Prod DI setups in separate classes
// - setup file to store secrets and config (similar to a .env file but using xcode)
// - VMs can/should be replaced with mocks for testing purposes
// - consider using DI not only services but also VMs
// - FIX THE ABSURD AMOUNT OF VMs CREATED
//  \- StandMasterVM for each stand in the list
//  \- TreeDetailsVM init and RE-init when the selected tree changes
// (should use `Self._printChanges()` but only for IOS 15+ projects ... which this Mac cannot use)

//let container : Container = {
//    let container = Container()
//    container.register(APIManaging.self) { _ in return MockAPIManager() }
//    return container
//}()

@main
struct TFEApp: App {
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    StandListView()
                        .environmentObject(StandListVM())
                }
                NotificationView()
            }
        }
    }
    
    private struct NotificationView: View {
        @StateObject private var notificationManager = NotificationManager.shared
        var body: some View {
            EmptyView()
                .toast(
                    message: notificationManager.notification?.message ?? "",
                    isShowing: $notificationManager.isShowingToast,
                    type: notificationManager.notification?.type ?? .info,
                    duration: 2
                )
        }
    }
}
