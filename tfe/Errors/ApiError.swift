//
//  ApiErrors.swift
//  tfe
//
//  Created by martin d'hoedt on 4/7/22.
//

import Foundation

enum ApiError: Error {
    case invalidRequest(_ msg: String)
    case unexpectedError(_ error: Error)
    case noInternetAccess(_ msg: String)
}

extension ApiError {
    var isFatal: Bool {
        if case ApiError.unexpectedError = self { return true }
        else { return false }
    }
}

extension ApiError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidRequest(_):
            return "An invalid request lead to an error."
        case .unexpectedError(_):
            return "An unexpected error occurred."
        case .noInternetAccess(_):
            return "No access to internet."
        }
    }
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRequest(_):
            return NSLocalizedString(
                "An invalid request lead to an error",
                comment: "Invalid request"
            )
        case .unexpectedError(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected error"
            )
        case .noInternetAccess(_):
            return NSLocalizedString(
                "No access to internet.",
                comment: "No access to internet"
            )
        }
    }
}
