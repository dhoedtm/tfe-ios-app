//
//  CustomMapView.swift
//  tfe
//
//  Created by martin d'hoedt on 4/25/22.
//

import Foundation
import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable {
    enum Action {
        case idle
        case reset(coordinate: CLLocationCoordinate2D)
        case changeType(mapType: MKMapType)
    }
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var action: Action
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.centerCoordinate = self.centerCoordinate
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        switch action {
        case .idle:
            break
        case .reset(let newCoordinate):
            uiView.delegate = nil
            uiView.centerCoordinate = newCoordinate
            DispatchQueue.main.async {
                self.centerCoordinate = newCoordinate
                self.action = .idle
                uiView.delegate = context.coordinator
            }
        case .changeType(let mapType):
            uiView.mapType = mapType
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
    }
}

