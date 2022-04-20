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

class StandMapVM : ObservableObject {

    // services
    private let api = ApiDataService.shared
    private let coreData = CoreDataService.shared
    private let notificationManager = NotificationManager.shared
    
    private var cancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    private var updateTreesCancellable : AnyCancellable?
        
    // UI
    @Published var isFetchingTrees : Bool = false
    
    // data
    @Published var selectedStand : StandEntity
    private let treeSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    @Published var trees : [TreeEntity] = [] {
        didSet {
            self.treeSelection()
        }
    }
    @Published var selectedTree : TreeEntity? {
        didSet {
            if let tree = self.selectedTree {
                updateMapRegion(tree: tree)
            }
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedTree"
    @Published var selectedTreeRegion : MKCoordinateRegion = MKCoordinateRegion()
    
    // MARK: init
    
    init(selectedStand: StandEntity) {
        self.selectedStand = selectedStand
        self.coreData.refreshLocalTreesForStand(id: selectedStand.id)
        self.subscribeToCoreDataResources()
    }
    
    // MARK: UI functions
    
    /// Handles the selection when:
    /// - the map is loaded for the first time
    /// - the trees are refreshed and references have become stale
    /// - the selected tree is deleted
    func treeSelection() {
        // stale reference to a selected tree that no longer exists
        let treeToSelect = self.trees.first(where: { entity in
            entity.id == (self.selectedTree?.id ?? 0)
        })
        // if no selectable tree was found, select the first tree in the list
        self.selectedTree = (treeToSelect != nil ? treeToSelect : self.trees.first ?? nil)
    }
    
    func getLocationFromCoordinates(tree: TreeEntity) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    private func getRegionFromCoordinates(tree: TreeEntity) -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // where to focus the map
            span: self.selectedTreeRegion.span // zoom amount
        )
    }
    
    func updateMapRegion(tree: TreeEntity) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
    
    // MARK: CORE DATA functions
    
    func subscribeToCoreDataResources() {
        self.coreData.$localTreeEntitiesForSelectedStand
            .sink { [weak self] (treeEntities) in
                let sortedTrees = treeEntities.sorted(by: { tree1, tree2 in
                    tree1.id < tree2.id
                })
                self?.trees = sortedTrees
            }
            .store(in: &cancellables)
    }
    
    func updateTrees() {
        self.isFetchingTrees = true
        self.updateTreesCancellable = self.coreData.fetchRemoteTreesForStand(id: self.selectedStand.id)
                .sink { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "Trees couldn't be updated\n(\(error.localizedDescription)",
                            type: .error)
                        break
                    case .finished:
                        self?.coreData.refreshLocalTreesForStand(id: self?.selectedStand.id ?? 0)
                        self?.notificationManager.notification = Notification(
                            message: "Trees inside this stand are now up to date",
                            type: .success)
                        self?.coreData.save()
                        self?.isFetchingTrees = false
                        break
                    }
                } receiveValue: { _ in }
    }
    
    func cancelTreesDownload() {
        self.isFetchingTrees = false
        self.updateTreesCancellable?.cancel()
    }
    
    func deleteTree(idTree: Int32) {
        api.deleteTree(idTree: idTree)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Tree couldn't be deleted\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.coreData.deleteLocalTree(id: idTree)
                self?.coreData.save()
            }
            .store(in: &cancellables)
    }
}

