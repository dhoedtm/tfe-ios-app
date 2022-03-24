//
//  TreesMapViewModel.swift
//  TFE
//
//  Created by user on 01/03/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class TreesMapViewModel : ObservableObject {
    
    let mapSpan : MKCoordinateSpan = {
        let mapZoomDelta = 0.005
        return MKCoordinateSpan(latitudeDelta: mapZoomDelta, longitudeDelta: mapZoomDelta)
    }()
    
    private let api = StandDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var error : String? = nil
    @Published var isFetchingTrees : Bool = false
    
    @Published var selectedStand : StandModel
    @Published var trees : [TreeModel] = [TreeModel]() {
        didSet {
            if (!self.trees.isEmpty) {
                self.selectedTree = self.trees.first
            }
        }
    }
    @Published var selectedTree : TreeModel? {
        didSet {
            // property observer, triggers after the variable "selectedTreeRegion" is set
            if (selectedTree == nil) {
                print("could not update map region, selected tree is nil")
                return
            }
            updateMapRegion(tree: selectedTree!)
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedTree"
    @Published var selectedTreeRegion : MKCoordinateRegion = MKCoordinateRegion() // blank initially
    
    init(selectedStand: StandModel) {
        self.selectedStand = selectedStand
        addSubscribers()
        api.getTreesForStand(idStand: self.selectedStand.id)
        self.isFetchingTrees = true
    }
    
    func addSubscribers() {
        api.$treesForStands
            .sink { [weak self] (trees) in
                self?.trees = trees[(self?.selectedStand.id)!] ?? [TreeModel]()
                self?.isFetchingTrees = false
            }
            .store(in: &cancellables)
    }
    
    func getLocationFromCoordinates(tree:TreeModel) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    func getRegionFromCoordinates(tree:TreeModel) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand to center map in the middle of the stand
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // center of the map, focus
            span: mapSpan // how much zoomed on the center
        )
    }
    
    private func updateMapRegion(tree: TreeModel) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
}

