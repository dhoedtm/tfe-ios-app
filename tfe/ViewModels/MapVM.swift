//
//  StandMapVM.swift
//  TFE
//
//  Created by user on 01/03/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class MapVM : ObservableObject {

    // services
    private let api = ApiDataService.shared
    private let dataStore = InMemoryDataStore.shared
    private let notificationManager = NotificationManager.shared
    private var cancellables: [AnyCancellable] = []
        
    // UI
    @Published var isFetchingTrees : Bool = false
    
    // data
    @Published var selectedStand : StandModel
    @Published var trees : [TreeModel] = [] {
        didSet {
            if let tree = self.trees.first {
                self.selectedTree = tree
            }
        }
    }
    @Published var selectedTree : TreeModel? {
        didSet {
            if let tree = selectedTree {
                updateMapRegion(tree: tree)
            }
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedTree"
    @Published var selectedTreeRegion : MKCoordinateRegion = MKCoordinateRegion()
    
    // MARK: init
    
    init(selectedStand: StandModel) {
        self.selectedStand = selectedStand
        self.isFetchingTrees = true
        self.subscribeToDataStore()
        getTrees()
    }
    
    // MARK: UI functions
    
    func reloadTrees() {
        withAnimation {
            self.isFetchingTrees = true
            api.getTreesSubscription?.cancel()
            getTrees()
        }
    }
    
    func getLocationFromCoordinates(tree:TreeModel) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    private func getRegionFromCoordinates(tree:TreeModel) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand to center map in the middle of the stand
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // center of the map, focus
            span: self.selectedTreeRegion.span // how much zoomed on the center
        )
    }
    
    func updateMapRegion(tree: TreeModel) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
    
    // MARK: DATA STORE functions
    
    func subscribeToDataStore() {
        dataStore.$treesForStands
            .sink { [weak self] (treesForStands) in
                let idStand = self?.selectedStand.id ?? 0
                self?.trees = treesForStands[idStand] ?? []
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getTrees() {
        api.getTreesSubscription = api.getTreesForStand(idStand: self.selectedStand.id)
            .sink {  [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Trees couldn't be retrieved\n(\(error.localizedDescription))",
                        type: .error
                    )
                    break
                case .finished:
                    break
                }
                self?.isFetchingTrees = false
            } receiveValue: { [weak self] (trees) in
                let id = self?.selectedStand.id ?? 0
                self?.dataStore.treesForStands[id] = trees
            }
        
    }
    
    func cancelTreesDownload() {
        self.isFetchingTrees = false
        api.getTreesSubscription?.cancel()
    }
    
    func deleteTree(idTree: Int) {
        api.deleteTree(idTree: idTree)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Tree couldn't be deleted\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    // TODO: only updates VM data, not dataStore
                    self?.trees.removeAll { tree in
                        return tree.id == idTree
                    }
                    // TODO: fix UI refresh based on dataStore selecting seemingly "random" trees
                    // the array could be sorted before selecting the tree in the didSet handler
                    // the dataStore could keep the array sorted at all times
                    // should probably used another data structure to make such manipulations more efficient
//                    if let tree = self?.selectedTree {
//                        self?.dataStore.deleteTree(tree: tree)
//                    }
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

