//
//  StandListViewModel.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
// import RxSwift

class StandListViewModel : ObservableObject {

    let api = container.resolve(APIManaging.self)!
    
    @Published var stands : [Stand]
    
    init() {
        self.stands = api.getStands()
    }
}
