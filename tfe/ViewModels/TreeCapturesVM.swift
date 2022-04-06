//
//  TreeFormVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation
import Combine

final class TreeCapturesVM: ObservableObject {
    
    private let api = ApiDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isFetchingCaptures : Bool = false
    @Published var isFetchingDiameters : Bool = false
    @Published var error : String? = nil
    
    @Published var selectedTree : TreeModel
    @Published var captures : [TreeCaptureModel] = []
    {
        didSet {
            if (!self.captures.isEmpty) {
                self.selectedCapture = self.captures.last!
                self.chartData = self.captures.map({ capture in
                    ChartData(
                        label: DateParser.shortenDateString(dateString: capture.capturedAt) ?? "date error",
                        value: capture.dbh)
                })
            }
        }
    }
    @Published var chartData : [ChartData] = []
    @Published var selectedCapture : TreeCaptureModel = TreeCaptureModel()
    {
        didSet {
            print("[selectedCapture] \(self.selectedCapture.id)")
            if (self.selectedCapture.id > 0) {
                self.isFetchingDiameters = true
                print("[selectedCapture] getting diameters for capture \(self.selectedCapture.id)")
                api.getDiametersForCapture(idCapture: self.selectedCapture.id)
            }
        }
    }
    @Published var diameters : [DiameterModel]  = []
    
    init(selectedTree: TreeModel) {
        self.selectedTree = selectedTree

        self.isFetchingCaptures = true
        
        addSubscribers()
        api.getCapturesForTree(idTree: self.selectedTree.id)
    }
    
    func addSubscribers() {
        api.$capturesForTrees
            .sink { [weak self] (trees) in
                self?.captures = trees[(self?.selectedTree.id)!] ?? []
                self?.isFetchingCaptures = false
            }
            .store(in: &cancellables)
        
        api.$diametersForCaptures
            .sink { [weak self] (captures) in
                let id = (self?.selectedCapture.id)!
                self?.diameters = captures[id] ?? []
                print("[api.$diametersForCaptures] \(id) : \(self?.diameters)")
                self?.isFetchingDiameters = false
            }
            .store(in: &cancellables)
    }
}
