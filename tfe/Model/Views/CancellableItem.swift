//
//  CancellableItem.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//

import Foundation
import Combine

struct CancellableItem : Identifiable, Hashable {
    let id: String = UUID().uuidString
    let cancellable: AnyCancellable
    let label: String
}
