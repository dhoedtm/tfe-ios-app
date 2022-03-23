//
//  APIManaging.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

struct TransferResult {
    let data: Data?
    let error: String?
}

typealias TransferCompletion = (TransferResult) -> ()

protocol APIManaging {
    func getStands(handler: @escaping TransferCompletion)
    func getTreesFromStand(idStand : Int, handler: @escaping TransferCompletion)
    func uploadPointCloud(filePath: URL, handler: @escaping TransferCompletion)
}
