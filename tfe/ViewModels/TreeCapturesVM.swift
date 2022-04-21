//
//  TreeFormVM.swift
//  tfe
//
//  Created by martin d'hoedt on 3/29/22.
//

import Foundation
import Combine

final class TreeCapturesVM: ObservableObject {
    
    // services
    private let api = ApiDataService.shared
    private let coreData = CoreDataService.shared
    private let notificationManager = NotificationManager.shared
    
    private var cancellables: [AnyCancellable] = []
    
    // ui
    
    // data
    @Published var selectedTree : TreeEntity
    @Published var captures : [TreeCaptureEntity] = []
    {
        didSet {
            if (!self.captures.isEmpty) {
                self.selectedCapture = self.captures.last!
                self.chartData = self.captures.map({ capture in
                    ChartData(
                        label: DateParser.shortenDateString(dateString: capture.capturedAt ?? "") ?? "date error",
                        value: capture.dbh)
                })
            }
        }
    }
    @Published var chartData : [ChartData] = []
    @Published var selectedCapture : TreeCaptureEntity = TreeCaptureEntity()
    {
        didSet {
            self.coreData.refreshLocalDiametersForCapture(id: self.selectedCapture.id)
        }
    }
    @Published var diameters : [DiameterEntity]  = []
    
    init(selectedTree: TreeEntity) {
        print("TreeCapturesVM - INIT")
        self.selectedTree = selectedTree
        self.subscribeToCoreDataResources()
        self.coreData.refreshLocalCapturesForTree(id: selectedTree.id)
    }
    
    // MARK: DATA STORE functions
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localTreeCapturesForSelectedTree
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { captureEntities in
                let sortedCaptures = captureEntities.sorted { capture1, capture2 in
                    (capture1.capturedAt ?? "") < (capture2.capturedAt ?? "")
                }
                self.captures = sortedCaptures
            }
            .store(in: &cancellables)
        
        self.coreData.$localDiametersForSelectedCapture
            .sink { diameterEntities in
                let sortedDiameters = diameterEntities.sorted { diam1, diam2 in
                    diam1.height < diam2.height
                }
                self.diameters = sortedDiameters
            }
            .store(in: &cancellables)
    }
}
