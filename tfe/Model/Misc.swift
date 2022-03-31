//
//  Misc.swift
//  tfe
//
//  Created by martin d'hoedt on 3/31/22.
//

import Foundation

struct ChartData : Comparable {
     var label: String
     var value: Double
}

extension ChartData {
    static func < (lhs: ChartData, rhs: ChartData) -> Bool {
        lhs.value < rhs.value
    }
}
