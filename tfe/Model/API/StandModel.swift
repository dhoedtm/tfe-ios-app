//
//  Stands.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

// Identifiable is required in order to be used in a List in a View
// items need to be uniquely identifiable, "id" could also be initiliazed with UUID()
// MARK: - Stand
struct StandModel: Identifiable, Codable, Hashable, Comparable {
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
    
extension StandModel {
    init(standFormState: StandFormState) {
//        guard
//            let id = ....
//        else {
//            // TODO: add throw ?
//        }
        id = Int(standFormState.id) ?? 0
        name = String(standFormState.name)
        treeCount = Int(standFormState.treeCount) ?? 0
        basalArea = Double(standFormState.basalArea) ?? 0
        convexAreaMeter = Double(standFormState.convexAreaMeter) ?? 0
        convexAreaHectare = Double(standFormState.convexAreaHectare) ?? 0
        concaveAreaMeter = Double(standFormState.concaveAreaMeter) ?? 0
        concaveAreaHectare = Double(standFormState.concaveAreaHectare) ?? 0
        treeDensity = Double(standFormState.treeDensity) ?? 0
        meanDbh = Double(standFormState.meanDbh) ?? 0
        meanDistance = Double(standFormState.meanDistance) ?? 0
        capturedAt = String(standFormState.capturedAt)
        description = String(standFormState.description)
    }
    
    
    init(standEntity: StandEntity) {
        id = Int(standEntity.id)
        name = standEntity.name ?? ""
        treeCount = Int(standEntity.treeCount)
        basalArea = standEntity.basalArea
        convexAreaMeter = standEntity.convexAreaMeter
        convexAreaHectare = standEntity.convexAreaHectare
        concaveAreaMeter = standEntity.concaveAreaMeter
        concaveAreaHectare = standEntity.concaveAreaHectare
        treeDensity = standEntity.treeDensity
        meanDbh = standEntity.meanDbh
        meanDistance = standEntity.meanDistance
        capturedAt = standEntity.capturedAt ?? ""
        description = standEntity.standDescription
    }
    
    static func < (lhs: StandModel, rhs: StandModel) -> Bool {
        lhs.id < rhs.id
    }
}

    // Codable protocol implements these behind the scenes
    // This would be needed had we implemented Codable, Decodable separately
    // Implementing Decodable might still be interesting for some special edge cases
    
//    /// Used by the encoder and decoder
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        ...
//    }
//
//    init(id : Int, name : String, treeCount : Int, basalArea : Double, ...) {
//        self.id = id
//        self.name = name
//        ...
//    }
//
//    /// From JSON data to model
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        ...
//    }
//
//    /// From model to JSON data
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        ...
//    }
