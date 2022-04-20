//
//  DataStoreError.swift
//  tfe
//
//  Created by martin d'hoedt on 4/14/22.
//

import Foundation

enum CoreDataError: Error {
    case entityNotFound(_ msg: String)
}

extension CoreDataError {
    var isFatal: Bool {
        if case CoreDataError.entityNotFound = self { return true }
        else { return false }
    }
}

extension CoreDataError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .entityNotFound(_):
            return "Entity could not be found."
        }
    }
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .entityNotFound(_):
            return NSLocalizedString(
                "Entity could not be found",
                comment: "Entity not found"
            )
        }
    }
}
