//
//  CancellableItem.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//

import Foundation
import Combine

struct CancellableItem : Identifiable, Hashable {
    let id: String
    let cancellable: AnyCancellable
    let label: String
    
    init(id: String, cancellable: AnyCancellable, label: String) {
        self.id = id
        self.cancellable = cancellable
        self.label = label
    }
}
