//
//  StandListViewModel.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import RxSwift

let api = container.resolve(APIManaging.self)!
let stands : [Stand] = api.getStands()
