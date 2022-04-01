//
//  TreeFormVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation

final class TreeCapturesVM: ObservableObject {
    
    @Published var selectedTree : TreeModel
    
    init(selectedTree: TreeModel) {
        self.selectedTree = selectedTree
    }
}
