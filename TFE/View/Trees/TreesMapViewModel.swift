//
//  TreesMapViewModel.swift
//  TFE
//
//  Created by user on 01/03/2022.
//

import Foundation
import MapKit
import SwiftUI

class TreesMapViewModel : ObservableObject {
    
    let mapSpan : MKCoordinateSpan = {
        let mapZoomDelta = 0.005
        return MKCoordinateSpan(latitudeDelta: mapZoomDelta, longitudeDelta: mapZoomDelta)
    }()
    
    let api = container.resolve(APIManaging.self)!
    
    @Published var error : String? = nil
    @Published var isFetchingTrees : Bool = false
    @Published var selectedStand : Stand
    @Published var trees : [Tree] = [Tree]() {
        didSet {
            if (!self.trees.isEmpty) {
                self.selectedTree = self.trees.first
            }
        }
    }
    @Published var selectedTree : Tree? {
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
    
    func getLocationFromCoordinates(tree:Tree) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude)
    }
    func getRegionFromCoordinates(tree:Tree) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand to center map in the middle of the stand
        return MKCoordinateRegion(
            center: getLocationFromCoordinates(tree: tree), // center of the map, focus
            span: mapSpan // how much zoomed on the center
        )
    }
    
    private func updateMapRegion(tree: Tree) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getRegionFromCoordinates(tree: tree)
        }
    }
    
    func fetchTrees(idStand: Int) {
        self.isFetchingTrees = true
        api.getTreesFromStand(
            idStand: selectedStand.id,
            handler: {
                [weak self] (returnedResult) in
                if let data = returnedResult.data {
                    guard let trees = try? JSONDecoder().decode([Tree].self, from: data) else {
                        self?.error = "Internal error while decoding Tree array"
                        self?.isFetchingTrees = false
                        return
                    }
                    self?.trees = trees
                } else {
                    self?.error = returnedResult.error ?? "Unknown error occured"
                }
                self?.isFetchingTrees = false
            }
        )
    }
    
    init(selectedStand: Stand) {
        self.selectedStand = selectedStand
        fetchTrees(idStand: self.selectedStand.id)
    }
}

