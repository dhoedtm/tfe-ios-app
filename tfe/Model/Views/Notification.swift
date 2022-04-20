//
//  Notification.swift
//  tfe
//
//  Created by martin d'hoedt on 4/7/22.
//

import Foundation
import SwiftUI

enum NotificationType : String, CaseIterable {
    case success
    case info
    case warning
    case error
}

struct Notification {
    let message: String
    let type: NotificationType
}

extension Notification {
    static func getIcon(type: NotificationType = .info) -> Image {
        switch type {
        case .info:
            return Image(systemName: "info.circle")
        case .success:
            return Image(systemName: "checkmark.circle")
        case .warning:
            return Image(systemName: "exclamationmark.triangle")
        case .error:
            return Image(systemName: "xmark.octagon")
        }
    }
    
    static func getColor(type: NotificationType = .info) -> Color {
        switch type {
        case .info:
            return Color.blue.opacity(0.9)
        case .success:
            return Color.green.opacity(0.9)
        case .warning:
            return Color.orange.opacity(0.9)
        case .error:
            return Color.red.opacity(0.9)
        }
    }
}


