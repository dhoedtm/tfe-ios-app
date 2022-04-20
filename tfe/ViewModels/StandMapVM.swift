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
        
    // UI
    @Published var isFetchingTrees : Bool = false
    
    // data
    @Published var selectedStand : StandEntity
    private let treeSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    @Published var trees : [TreeEntity] = [] {
        didSet {
            if let tree = self.trees.first {
                // auto select 1st tree the 1st time the map is populated
                if (self.selectedTree == nil) {
                    self.selectedTree = tree
                }
            }
        }
    }
    @Published var selectedTree : TreeEntity? {
        didSet {
            print("SELECTED : \(self.selectedTree)")
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
        self.subscribeToCoreDataResources()
    }
    
    // MARK: UI functions
    
    func getLocationFromCoordinates(tree: TreeEntity) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    private func getRegionFromCoordinates(tree: TreeEntity) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand to center map in the middle of the stand
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // center of the map, focus
            span: self.selectedTreeRegion.span // how much zoomed on the center
        )
    }
    
    func updateMapRegion(tree: TreeEntity) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
    
    // MARK: CORE DATA functions
    
    func subscribeToCoreDataResources() {
        self.coreData.$localStandEntities
            .sink { [weak self] (standEntities) in
                self?.refreshTreesForStand(standEntities: standEntities)
            }
            .store(in: &cancellables)
    }
    
    func refreshTreesForStand(standEntities: [StandEntity]) {
        for standEntity in standEntities {
            if (standEntity.id == self.selectedStand.id) {
                self.selectedStand = standEntity
                var sortedTrees : [TreeEntity] = standEntity.trees?.allObjects as! [TreeEntity]
                sortedTrees.sort(by: { tree1, tree2 in
                    tree1.id < tree2.id
                })
                self.trees = sortedTrees
            }
        }
    }
    
    func updateTrees() {
        self.coreData.updateTreesForStand(id: self.selectedStand.id)
                .sink { [weak self] (completion) in
                    switch completion {
                    case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "Trees couldn't be updated\n(\(error.localizedDescription)",
                            type: .error)
                        break
                    case .finished:
                        self?.refreshTreesForStand(standEntities: (self?.coreData.localStandEntities)!)
                        self?.notificationManager.notification = Notification(
                            message: "Trees inside this stand are now up to date",
                            type: .success)
                        break
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
    }
    
    func cancelTreesDownload() {
        
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
                    self?.coreData.deleteTreeById(id: idTree)
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

