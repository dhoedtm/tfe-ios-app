//
//  ViewExtensions.swift
//  tfe
//
//  Created by martin d'hoedt on 4/2/22.
//

import Foundation
import SwiftUI

extension View {
    func debugAction(_ closure: () -> Void) -> Self {
        #if DEBUG
        closure()
        #endif

        return self
    }
    
    func debugPrint(_ value: Any) -> Self {
        debugAction { print(value) }
    }
    
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
        #if DEBUG
        return modifier(self)
        #else
        return self
        #endif
    }
    
    /// Adds a border to a given View
    /// Default color is Color.red
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }
    
    /// Adds a background to a given View
    /// Default color is Color.red
    func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }
}
