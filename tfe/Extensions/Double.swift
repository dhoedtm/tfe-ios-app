//
//  Double.swift
//  tfe
//
//  Created by martin d'hoedt on 3/30/22.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Rounds the double to decimal places value and returns it as a String
    func roundedToString(toPlaces places:Int) -> String {
        return String(rounded(toPlaces: places))
    }
}
