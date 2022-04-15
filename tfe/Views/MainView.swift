//
//  MainView.swift
//  tfe
//
//  Created by martin d'hoedt on 4/15/22.
//

import SwiftUI

struct MainView: View {
    
    let title = "Local data synchronization"
    let message : String = {
        var message = "It looks like you have access to the internet.\n"
        message += "Would you like to sync with the API ?"
        return message
    }()
    
    @EnvironmentObject private var vm : MainVM
    
    var body: some View {
        if (vm.hasInternetConnection && vm.wantsToSync) {
            syncAlert
                .navigationBarHidden(true)
        } else {
            StandListView()
                .environmentObject(StandListVM())
        }
    }
}

extension MainView {
    private var syncAlert : some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
            Text(message)
            HStack {
                Button(action: vm.isSyncingWithApi ? vm.cancelSync : vm.sync, label: {
                    HStack {
                        Text(vm.isSyncingWithApi ? "Cancel sync" : "Sync")
                        Spacer()
                        Image(systemName: vm.isSyncingWithApi ? "xmark" : "icloud.and.arrow.down")
                    }
                    .padding(10)
                })
                .padding(5)
                .background(Color.green)
                .accentColor(.white)
                .overlay(vm.isSyncingWithApi ? Color.black.opacity(0.2) : Color.clear)
                .cornerRadius(10)
                
                Button(action: { vm.wantsToSync = false }, label: {
                    HStack{
                        Text("Local data")
                        Spacer()
                        Image(systemName: "internaldrive")
                    }
                    .padding(10)
                })
                .padding(5)
                .background(Color.green)
                .accentColor(.white)
                .overlay(vm.isSyncingWithApi ? Color.black.opacity(0.2) : Color.clear)
                .cornerRadius(10)
            }
            .disabled(vm.isSyncingWithApi)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainVM())
    }
}
