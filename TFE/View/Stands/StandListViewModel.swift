//
//  StandListViewModel.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import MapKit
import SwiftUI
// import RxSwift

class StandListViewModel : ObservableObject {

    
    let mapSpan : MKCoordinateSpan = {
        let mapZoomDelta = 0.005
        return MKCoordinateSpan(latitudeDelta: mapZoomDelta, longitudeDelta: mapZoomDelta)
    }()
    
    let api = container.resolve(APIManaging.self)!
    
    @Published var stands : [Stand]
    @Published var selectedStand : Stand? {
        didSet {
            if (selectedStand != nil) {
                if let firstTree = selectedStand!.trees.first {
                    selectedTree = firstTree
                } else {
                    print("tree list for selected stand is empty")
                    selectedTree = nil
                }
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
    
    func getLocationFromCoordinates(tree:Tree) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: tree.latitude, longitude: tree.longitude), // center of the map, focus
            span: mapSpan // how much zoomed on the center
        )
    }
    
    private func updateMapRegion(tree: Tree) {
        withAnimation(.easeInOut) {
            selectedTreeRegion = getLocationFromCoordinates(tree: tree)
        }
    }
    
    init() {
        let stands = api.getStands()
        self.stands = stands
        
        // TODO: messy, amount of if statements would grow with deeper levels of nested data
        // could use alamofire to better handle missing/empty data ?
        if let firstStand = stands.first {
            self.selectedStand = firstStand
            if let firstTree = selectedStand!.trees.first {
                self.selectedTree = firstTree
            } else {
                print("tree list for selected stand is empty")
                self.selectedTree = nil
            }
        } else {
            print("no stand could be selected as the retrieved stands list is empty")
            self.selectedStand = nil
        }
    }
}
