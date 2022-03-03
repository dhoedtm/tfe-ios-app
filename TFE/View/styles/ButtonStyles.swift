//
//  ButtonStyles.swift
//  TFE
//
//  Created by user on 03/03/2022.
//

import Foundation
import SwiftUI

struct StandardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color(red:0.9, green:0.9, blue:0.9))
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
}
