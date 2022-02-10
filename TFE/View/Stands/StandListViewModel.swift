//
//  StandListViewModel.swift
//  TFE
//
//  Created by user on 09/02/2022.
//

import Foundation
import RxSwift

enum StandViewCellType {
    case normal(model: Stand)
    case error(message: String)
    case empty
}

// let api = container.resolve(APIManaging.self)

class StandListViewModel {

    var standCells: Observable {
        return cells.asObservable()
    }
    
    var onShowLoadingHud: Observable {
        return loadingProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    let onShowError = PublishSubject()
    let api: APIManaging
    let disposeBad = DisposeBag()
    
    private let loadInProgress = Variable(false)
    private let cells = Variable([])
    
    // let stands = api?.getStands()
}
