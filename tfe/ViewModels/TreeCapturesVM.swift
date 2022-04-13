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
    private let dataStore = InMemoryDataStore.shared
    private let notificationManager = NotificationManager.shared
    private var cancellables: [AnyCancellable] = []
    
    // ui
    @Published var isFetchingCaptures : Bool = false
    @Published var isFetchingDiameters : Bool = false
    
    // data
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
    @Published var diameters : [DiameterModel]  = []
    
    init(selectedTree: TreeModel) {
        self.selectedTree = selectedTree
        subscribeToDataStore()
        getCaptures()
        self.isFetchingCaptures = true
    }
    
    // MARK: DATA STORE functions
    
    func subscribeToDataStore() {
        dataStore.$capturesForTrees
            .sink { capturesForTrees in
                self.captures = capturesForTrees[self.selectedTree.id] ?? []
            }
            .store(in: &cancellables)
        
        dataStore.$diametersForCaptures
            .sink { diametersForCaptures in
                self.diameters = diametersForCaptures[self.selectedCapture.id] ?? []
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getCaptures() {
        self.isFetchingCaptures = true
        api.getCapturesSubscription = api.getCapturesForTree(idTree: self.selectedTree.id)
            .sink {  [weak self] (completion) in
                switch completion {
                case .failure(let error):
                        self?.notificationManager.notification = Notification(
                            message: "captures couldn't be retrieved\n(\(error.localizedDescription))",
                            type: .error)
                    break
                case .finished:
                    break
                }
                self?.isFetchingCaptures = false
            } receiveValue: { [weak self] (captures) in
                if let selectedTree = self?.selectedTree {
                    self?.dataStore.capturesForTrees[selectedTree.id] = captures
                }
                self?.getDiameters()
            }
    }
    
    func getDiameters() {
        self.isFetchingDiameters = true
        api.getDiametersSubscription = api.getDiametersForCapture(idCapture: self.selectedCapture.id)
            .sink {  [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                            message: "diameters couldn't be retrieved\n(\(error.localizedDescription))",
                            type: .error)
                    break
                case .finished:
                    break
                }
                self?.isFetchingDiameters = false
            } receiveValue: { [weak self] (diameters) in
                if let treeCapture = self?.selectedCapture {
                    self?.dataStore.diametersForCaptures[treeCapture.id] = diameters
                }
            }
    }
}
