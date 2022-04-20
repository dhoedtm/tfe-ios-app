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
    @Published var isFetchingCaptures : Bool = false
    @Published var isFetchingDiameters : Bool = false
    
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
    @Published var selectedCapture : TreeCaptureEntity? = nil
    @Published var diameters : [DiameterEntity]  = []
    
    init(selectedTree: TreeEntity) {
        self.selectedTree = selectedTree
        subscribeToCoreDataResources()
        self.coreData.refreshLocalCaptureForTree(id: selectedTree.id)
        self.isFetchingCaptures = true
    }
    
    // MARK: DATA STORE functions
    
    private func subscribeToCoreDataResources() {
        self.coreData.$localTreeCapturesForSelectedTree
            .sink { captureEntities in
                self.captures = captureEntities
            }
            .store(in: &cancellables)
        
        self.coreData.$localDiametersForSelectedCapture
            .sink { diameterEntities in
                self.diameters = diameterEntities
            }
            .store(in: &cancellables)
    }
    
    // MARK: API functions
    
    func getCaptures() {
        self.isFetchingCaptures = true
        self.coreData.fetchRemoteCapturesForTree(id: self.selectedTree.id)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Captures couldn't be updated\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    self?.coreData.refreshLocalCaptureForTree(id: self?.selectedTree.id ?? 0)
                    self?.coreData.save()
                    self?.isFetchingCaptures = false
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func getDiameters() {
        self.isFetchingDiameters = true
        self.coreData.fetchRemoteTreesForStand(id: self.selectedTree.id)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.notificationManager.notification = Notification(
                        message: "Diameters couldn't be updated\n(\(error.localizedDescription)",
                        type: .error)
                    break
                case .finished:
                    self?.coreData.refreshLocalDiametersForCapture(id: (self?.selectedCapture!.id)!)
                    self?.coreData.save()
                    self?.isFetchingDiameters = false
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
