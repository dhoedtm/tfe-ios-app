//
//  DataStoreError.swift
//  tfe
//
//  Created by martin d'hoedt on 4/14/22.
//

import Foundation

enum DataStoreError: Error {
    case invalidRequest(_ msg: String)
    case unexpectedError(_ error: Error)
}

extension DataStoreError {
    var isFatal: Bool {
        if case DataStoreError.unexpectedError = self { return true }
        else { return false }
    }
}

extension DataStoreError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidRequest(_):
            return "An invalid request lead to an error."
        case .unexpectedError(_):
            return "An unexpected error occurred."
        }
    }
}

extension DataStoreError: LocalizedError {
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
        }
    }
}
