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
    @Published var selectedStand : Stand {
        didSet {
            // reflects changes to the variable "selectedStandRegion"
            updateMapRegion(stand: selectedStand)
        }
    }
    // automatically updated via the "didSet" trigger on the variable "selectedStand"
    @Published var selectedStandRegion : MKCoordinateRegion = MKCoordinateRegion() // blank initially
    
    func getLocationFromCoordinates(stand:Stand) -> MKCoordinateRegion {
        // TODO: retrieve lat, long from stand
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50.708225, longitude: 4.352829), // center of the map, focus
            span: mapSpan // how much zoomed on the center
        )
    }
    
    private func updateMapRegion(stand: Stand) {
        withAnimation(.easeInOut) {
            selectedStandRegion = getLocationFromCoordinates(stand: stand)
        }
    }
    
    init() {
        let stands = api.getStands()
        self.stands = stands
        // Explicit unwrap of the 1st item with "!"
        // Not safe for network retrieved information
        // TODO: better handle failures (try/catch ? using alamofire ?)
        self.selectedStand = stands.first!
        
        self.updateMapRegion(stand: selectedStand)
    }
}
