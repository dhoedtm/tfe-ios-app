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
    
    enum StandMapError : Hashable {
        case trees
        case selectedTree
    }
    
    // MARK: VARIABLES
    
    let mapSpan : MKCoordinateSpan = {
        let mapZoomDelta = 0.005
        return MKCoordinateSpan(latitudeDelta: mapZoomDelta, longitudeDelta: mapZoomDelta)
    }()
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    private var errors : Dictionary<StandMapError, String> = Dictionary<StandMapError, String>() {
        didSet{
            errorList = Array(errors.values)
        }
    }
    
    @Published var errorList : [String] = []
    @Published var isFetchingTrees : Bool = false
    
    @Published var selectedStand : StandModel
    @Published var trees : [TreeModel] = [TreeModel]() {
        didSet {
            guard let tree = self.trees.first else {
                errors[.trees] = "this stand has no trees"
                return
            }
            self.selectedTree = tree
            errors[.trees] = nil
        }
    }
    @Published var selectedTree : TreeModel? {
        didSet {
            // property observer, triggers after the variable "selectedTreeRegion" is set
            guard let tree = selectedTree else {
                errors[.selectedTree] = "could not update map region, selected tree is nil"
                return
            }
            updateMapRegion(tree: tree)
            errors[.selectedTree] = nil
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedTree"
    @Published var selectedTreeRegion : MKCoordinateRegion = MKCoordinateRegion() // blank initially
    
    // MARK: INIT
    
    init(selectedStand: StandModel) {
        self.selectedStand = selectedStand
        addSubscribers()
        api.getTreesForStand(idStand: self.selectedStand.id)
        self.isFetchingTrees = true
    }
    
    // MARK: FUNCTIONS
    
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
            span: self.selectedTreeRegion.span // how much zoomed on the center
        )
    }
    
    func updateMapRegion(tree: TreeModel) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
}

