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
struct StandModel: Identifiable, Codable {
    let id: Int
    let name: String
    let treeCount: Int
    let basalArea: Double
    let convexAreaMeter: Double
    let convexAreaHectare: Double
    let concaveAreaMeter: Double
    let concaveAreaHectare: Double
    let treeDensity: Double
    let meanDbh: Double
    let meanDistance: Int
    let captureDate: String
    let description: String
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
