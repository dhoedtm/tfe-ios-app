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
            .frame(maxWidth: .infinity)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
    }
}
