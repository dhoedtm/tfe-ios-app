//
//  APIManaging.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation

protocol APIManaging {
    func getStands() -> [Stand]
    func getTreesFromStand(idStand : Int) -> [Tree]
    func uploadPointCloud(filePath: URL)
}
