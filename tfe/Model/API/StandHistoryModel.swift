//
//  StandHistoryModel.swift
//  tfe
//
//  Created by martin d'hoedt on 4/3/22.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
// MARK: - Stand
struct StandHistoryModel: Identifiable, Codable, Hashable, Comparable {
    var id: Int
    var name: String
    var treeCount: Int
    var basalArea: Double
    var convexAreaMeter: Double
    var convexAreaHectare: Double
    var concaveAreaMeter: Double
    var concaveAreaHectare: Double
    var treeDensity: Double
    var meanDbh: Double
    var meanDistance: Double
    var capturedAt: String
    var description: String?
}

extension StandHistoryModel {
    init() {
        self.id = 0
        self.name = ""
        self.treeCount = 0
        self.basalArea = 0
        self.convexAreaMeter = 0
        self.convexAreaHectare = 0
        self.concaveAreaMeter = 0
        self.concaveAreaHectare = 0
        self.treeDensity = 0
        self.meanDbh = 0
        self.meanDistance = 0
        self.capturedAt = ""
        self.description = ""
    }
    
    static func < (lhs: StandHistoryModel, rhs: StandHistoryModel) -> Bool {
        lhs.id < rhs.id
    }
}
