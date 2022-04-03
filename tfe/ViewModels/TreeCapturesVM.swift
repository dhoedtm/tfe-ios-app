//
//  TreeFormVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation

final class TreeCapturesVM: ObservableObject {
    
    @Published var selectedTree : TreeModel
    @Published var captures : [TreeCaptureModel] // = []
    @Published var selectedCapture : TreeCaptureModel?
    @Published var diameters : [DiameterModel] // = []
    
    init(selectedTree: TreeModel, captures: [TreeCaptureModel], diameters: [DiameterModel]) {
        self.selectedTree = selectedTree
        self.captures = captures
        self.selectedCapture = captures.first
        self.diameters = diameters
    }
}
