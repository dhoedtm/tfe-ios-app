//
//  CoreDataVM.swift
//  tfe
//
//  Created by martin d'hoedt on 4/5/22.
//

import Foundation
import CoreData
import Combine

enum CoreDataEntities : String {
    case StandEntity
    case StandHistoryEntity
    case TreeEntity
    case TreeCaptureEntity
    case DiameterEntity
}

class CoreDataService: ObservableObject {
    let manager = CoreDataManager.shared
    let api = ApiDataService.shared
    private var subscriptions : Set<AnyCancellable> = []
    
    @Published var localStandEntities: [StandEntity] = []
    
    static let shared = CoreDataService()
    private init() {
        self.fetchLocalStands()
    }
    
    func saveAndRefresh() {
        manager.save()
        fetchLocalStands()
    }
    
    // MARK: API SYNC
    
    /// Purges local data, than fetches remote data from the API
    ///
    /// Publisher cascade :
    ///
    /// ``` plaintext
    /// Stands
    /// \----> Histories
    /// \----> Trees (leaf, return true)
    ///     \----> Captures
    ///         \----> Diameters (leaf, return true)
    /// ```
    /// It finally, stores local CoreData entities into persistent storage
    func oneWayApiSync() -> AnyPublisher<Bool, Error> {
        return api.getStands()
            .receive(on: DispatchQueue.global(qos: .background))
            .map({ standModels -> [StandEntity] in
                standModels.map { standModel in
                    self.updateOrCreateStandEntityFromModel(standModel: standModel)
                }
            })
            .flatMap({ standEntities -> AnyPublisher<Bool, Error> in
                // remove stand that no longer exists on the remote server
                Set(self.localStandEntities)
                    .subtracting(standEntities)
                    .forEach({ stand in
                        self.manager.context.delete(stand)
                })
                // query and insert relationship data into fetched stands
                return Publishers
                    .MergeMany([
                        self.populateStandHistories(standEntities: standEntities),
                        self.populateStandTrees(standEntities: standEntities)
                    ])
                    .reduce(true, { accumulator, isCurrOk in
                        accumulator && isCurrOk
                    })
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// purges local data before syncing
    func hardOneWayApiSync() -> AnyPublisher<Bool, Error> {
        // purges local data
        manager.resetContainer()
        // fetches data
        return oneWayApiSync()
    }
    
    // TODO: refactor "populate" code, make it generic and keep it DRY
    
    func populateStandHistories(standEntities: [StandEntity]) -> AnyPublisher<Bool, Error> {
        
        var publishers : [AnyPublisher<Bool, Error>] = []
        
        for standEntity in standEntities {
            let publisher = self.api.getHistoriesForStand(idStand: Int(standEntity.id))
                .map({ historyModels -> [StandHistoryEntity] in
                    historyModels.map { historyModel in
                        self.updateOrCreateHistoryEntityFromModel(history: historyModel)
                    }
                })
                .map({ historyEntities -> Bool in
                    // remove histories that no longer exists on the remote server
                    Set(self.getHistoriesForStand(id: standEntity.id))
                        .subtracting(historyEntities)
                        .forEach({ history in
                            self.manager.context.delete(history)
                    })
                    // update local histories
                    standEntity.addToHistories(NSSet(array: historyEntities))
                    for historyEntity in historyEntities {
                        historyEntity.stand = standEntity
                    }
                    return true
                })
                .eraseToAnyPublisher()
            
            publishers.append(publisher)
        }
        
        return Publishers
            .MergeMany(publishers)
            .reduce(true, { accumulator, isCurrOk in
                accumulator && isCurrOk
            })
            .eraseToAnyPublisher()
    }
    
    func populateStandTrees(standEntities: [StandEntity]) -> AnyPublisher<Bool, Error> {
        
        var publishers : [AnyPublisher<Bool, Error>] = []
        
        for standEntity in standEntities {
            let publisher = self.api.getTreesForStand(idStand: Int(standEntity.id))
                .map({ treeModels -> [TreeEntity] in
                    treeModels.map { treeModel in
                        self.updateOrCreateTreeEntityFromModel(treeModel: treeModel)
                    }
                })
                .flatMap({ treeEntities -> AnyPublisher<Bool, Error> in
                    // remove trees that no longer exists on the remote server
                    Set(self.getTreesForStand(id: standEntity.id))
                        .subtracting(treeEntities)
                        .forEach({ tree in
                            self.manager.context.delete(tree)
                    })
                    // update local trees
                    standEntity.addToTrees(NSSet(array: treeEntities))
                    for treeEntity in treeEntities {
                        treeEntity.stand = standEntity
                    }
                    return self.populateTreeCaptures(treeEntities: treeEntities)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()

            publishers.append(publisher)
        }
        
        return Publishers
            .MergeMany(publishers)
            .reduce(true, { accumulator, isCurrOk in
                accumulator && isCurrOk
            })
            .eraseToAnyPublisher()
    }
    
    func populateTreeCaptures(treeEntities: [TreeEntity]) -> AnyPublisher<Bool, Error> {
        
        var publishers : [AnyPublisher<Bool, Error>] = []
        
        for treeEntity in treeEntities {
            let publisher = self.api.getCapturesForTree(idTree: Int(treeEntity.id))
                .map({ captureModels -> [TreeCaptureEntity] in
                    captureModels.map { captureModel in
                        self.updateOrCreateCaptureEntityFromModel(captureModel: captureModel)
                    }
                })
                .flatMap({ captureEntities -> AnyPublisher<Bool, Error> in
                    // remove captures that no longer exists on the remote server
                    Set(self.getCapturesForTree(id: treeEntity.id))
                        .subtracting(captureEntities)
                        .forEach({ capture in
                            self.manager.context.delete(capture)
                    })
                    // update local captures
                    treeEntity.addToCaptures(NSSet(array: captureEntities))
                    for captureEntity in captureEntities {
                        captureEntity.tree = treeEntity
                    }
                    return self.populateCaptureDiameters(captureEntities: captureEntities)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
            
            publishers.append(publisher)
        }
        
        return Publishers
            .MergeMany(publishers)
            .reduce(true, { accumulator, isCurrOk in
                accumulator && isCurrOk
            })
            .eraseToAnyPublisher()
    }
    
    func populateCaptureDiameters(captureEntities: [TreeCaptureEntity]) -> AnyPublisher<Bool, Error> {
        
        var publishers : [AnyPublisher<Bool, Error>] = []
        
        for captureEntity in captureEntities {
            let publisher = self.api.getDiametersForCapture(idCapture: Int(captureEntity.id))
                .map({ diametersModels -> [DiameterEntity] in
                    diametersModels.map { diametersModel in
                        self.updateOrCreateDiameterEntityFromModel(diameterModel: diametersModel)
                    }
                })
                .map({ diameterEntities -> Bool in
                    // remove diameters that no longer exists on the remote server
                    Set(self.getDiametersForCapture(id: captureEntity.id))
                        .subtracting(diameterEntities)
                        .forEach({ diameter in
                            self.manager.context.delete(diameter)
                    })
                    // update local diameters
                    captureEntity.addToDiameters(NSSet(array: diameterEntities))
                    for diameterEntity in diameterEntities {
                        diameterEntity.capture = captureEntity
                    }
                    return true
                })
                .eraseToAnyPublisher()
            
            publishers.append(publisher)
        }
        
        return Publishers
            .MergeMany(publishers)
            .reduce(true, { accumulator, isCurrOk in
                accumulator && isCurrOk
            })
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("[oneWaySyncWithApi - completion] error : \(error)")
            break
        }
    }
    
    func fetchLocalStands() {
        let nameSort = NSSortDescriptor(key:"name", ascending:true)
        let request = NSFetchRequest<StandEntity>(entityName: CoreDataEntities.StandEntity.rawValue)
        request.sortDescriptors = [nameSort]
        do {
            localStandEntities = try manager.context.fetch(request)
        } catch (let error) {
            print("[CoreDataVM][fetchStands] error : \(error)")
        }
    }
    
    // MARK: STANDS
    
    func addStand(stand: StandModel) -> AnyPublisher<Bool, Error> {
        let standEntity = updateOrCreateStandEntityFromModel(standModel: stand)
        
        return Publishers
            .MergeMany([
                        self.populateStandHistories(standEntities: [standEntity]),
                self.populateStandTrees(standEntities: [standEntity])
            ])
            .reduce(true, { accumulator, isCurrOk in
                accumulator && isCurrOk
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func updateStand(entity: StandEntity, stand: StandModel) {
        let _ = updateOrCreateStandEntityFromModel(entity: entity, standModel: stand)
        saveAndRefresh()
    }
    func getStandEntityById(id: Int32) -> StandEntity? {
        return localStandEntities.first { entity in
            entity.id == id
        }
    }
    func deleteStandById(id: Int32) {
        guard let validEntity = getStandEntityById(id: id)
        else {
            print("[CoreDataVM][deleteStand] stand not found")
            return
        }
        manager.context.delete(validEntity)
        saveAndRefresh()
    }
    
    // MARK: HISTORIES
    
    func addHistoriesToStand(standId: Int32, histories: [StandHistoryModel]) {
        guard let standEntity = getStandEntityById(id: standId)
        else {
            print("[CoreDataVM][addHistoriesToStand] stand not found")
            return
        }
        for history in histories {
            let historyEntity  = StandHistoryEntity(context: manager.context)
            let _ = mapStandHistoryModelToStandHistoryEntity(historyModel: history, entity: historyEntity)
            historyEntity.stand = standEntity
            standEntity.addToHistories(historyEntity)
        }
        saveAndRefresh()
    }
    
    func getHistoriesForStand(id: Int32) -> [StandHistoryEntity] {
        let fetchRequest : NSFetchRequest<StandHistoryEntity> = StandHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "idStand = %d", id
        )
        do {
            let historyEntities = try manager.context.fetch(fetchRequest)
            return historyEntities
        } catch(let error) {
            print("[CoreDataEntities][deleteTreeById] ERROR : \(error)")
        }
        return []
    }
    
    // MARK: TREES
    
    func addTreesToStand(standId: Int32, trees: [TreeModel]) {
        guard let standEntity = getStandEntityById(id: standId)
        else {
            print("[CoreDataVM][addTreesToStand] stand not found")
            return
        }
        for tree in trees {
            let treeEntity  = TreeEntity(context: manager.context)
            let _ = mapTreeModelToTreeEntity(treeModel: tree, entity: treeEntity)
            standEntity.addToTrees(treeEntity)
            treeEntity.stand = standEntity
        }
        saveAndRefresh()
    }
    
    func getTreeEntityById(id: Int32) -> TreeEntity? {
        let fetchRequest : NSFetchRequest<TreeEntity> = TreeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id = %d", id
        )
        do {
            let treeEntities = try manager.context.fetch(fetchRequest)
            return treeEntities.first
        } catch(let error) {
            print("[CoreDataEntities][getTreeEntityById] ERROR : \(error)")
        }
        return nil
    }
    
    func getTreesForStand(id: Int32) -> [TreeEntity] {
        let fetchRequest : NSFetchRequest<TreeEntity> = TreeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "idStand = %d", id
        )
        do {
            let treeEntities = try manager.context.fetch(fetchRequest)
            return treeEntities
        } catch(let error) {
            print("[CoreDataEntities][getTreesForStand] ERROR : \(error)")
        }
        return []
    }
    
    func updateTreesForStand(id: Int32) -> AnyPublisher<Bool, Error> {
        guard let standEntity = getStandEntityById(id: id) else {
            print("[CoreDataService][updateTreesForStand] stand not found")
            return createMissingEntityPublisher(message: "stand not found")
        }
        guard let trees = standEntity.trees else {
            print("[CoreDataService][updateTreesForStand] no trees found")
            return createMissingEntityPublisher(message: "no trees found")
        }
        
        // purge tree data for stand
        for tree in trees {
            manager.context.delete(tree as! TreeEntity)
        }
        // populate tree data for stand
        return self.populateStandTrees(standEntities: [standEntity])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteTreeById(id: Int32) { //}-> Bool {
        saveAndRefresh()
    }
    
    // MARK: CAPTURES
    
    func getCapturesForTree(id: Int32) -> [TreeCaptureEntity] {
        let fetchRequest : NSFetchRequest<TreeCaptureEntity> = TreeCaptureEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "idTree = %d", id
        )
        do {
            let captureEntities = try manager.context.fetch(fetchRequest)
            return captureEntities
        } catch(let error) {
            print("[CoreDataEntities][getCapturesForTree] ERROR : \(error)")
        }
        return []
    }
    
    // MARK: DIAMETERS
    
    func getDiametersForCapture(id: Int32) -> [DiameterEntity] {
        let fetchRequest : NSFetchRequest<DiameterEntity> = DiameterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "idTreeCapture = %d", id
        )
        do {
            let captureEntities = try manager.context.fetch(fetchRequest)
            return captureEntities
        } catch(let error) {
            print("[CoreDataEntities][getDiametersForCapture] ERROR : \(error)")
        }
        return []
    }
    
    // MARK: ENTITY CREATION
    
    /// Updates the provided entity, or creates a new StandEntity in the container if none is provided
    func updateOrCreateStandEntityFromModel(entity: StandEntity? = nil, standModel: StandModel)
    -> StandEntity
    {
        let localStandEntity : StandEntity = {
            if let entity : StandEntity = entity {
                return entity
            }
            return StandEntity(context: manager.context)
        }()
        return mapStandModelToStandEntity(standModel: standModel, entity: localStandEntity)
    }
    
    func updateOrCreateHistoryEntityFromModel(entity: StandHistoryEntity? = nil, history: StandHistoryModel)
    -> StandHistoryEntity
    {
        let localHistoryEntity : StandHistoryEntity = {
            if let entity : StandHistoryEntity = entity {
                return entity
            }
            return StandHistoryEntity(context: manager.context)
        }()
        return mapStandHistoryModelToStandHistoryEntity(historyModel: history, entity: localHistoryEntity)
    }
    
    func updateOrCreateTreeEntityFromModel(entity: TreeEntity? = nil, treeModel: TreeModel)
    -> TreeEntity
    {
        let localTreeEntity : TreeEntity = {
            if let entity : TreeEntity = entity {
                return entity
            }
            return TreeEntity(context: manager.context)
        }()
        return mapTreeModelToTreeEntity(treeModel: treeModel, entity: localTreeEntity)
    }
    
    func updateOrCreateCaptureEntityFromModel(entity: TreeCaptureEntity? = nil, captureModel: TreeCaptureModel)
    -> TreeCaptureEntity
    {
        let localCaptureEntity : TreeCaptureEntity = {
            if let entity : TreeCaptureEntity = entity {
                return entity
            }
            return TreeCaptureEntity(context: manager.context)
        }()
        return mapCaptureModelToCaptureEntity(captureModel: captureModel, entity: localCaptureEntity)
    }
    
    func updateOrCreateDiameterEntityFromModel(entity: DiameterEntity? = nil, diameterModel: DiameterModel)
    -> DiameterEntity
    {
        let localDiameterEntity : DiameterEntity = {
            if let entity : DiameterEntity = entity {
                return entity
            }
            return DiameterEntity(context: manager.context)
        }()
        return mapDiameterModelToDiameterEntity(diameterModel: diameterModel, entity: localDiameterEntity)
    }
    
    // MARK: MAPPING
    
    func mapStandModelToStandEntity(standModel: StandModel, entity: StandEntity)
    -> StandEntity
    {
        entity.id = Int32(standModel.id)
        entity.name = standModel.name
        entity.treeCount = Int16(standModel.treeCount)
        entity.basalArea = standModel.basalArea
        entity.convexAreaMeter = standModel.convexAreaMeter
        entity.convexAreaHectare = standModel.convexAreaHectare
        entity.concaveAreaMeter = standModel.concaveAreaMeter
        entity.concaveAreaHectare = standModel.concaveAreaHectare
        entity.treeDensity = standModel.treeDensity
        entity.meanDbh = standModel.meanDbh
        entity.meanDistance = standModel.meanDistance
        entity.capturedAt = standModel.capturedAt
        entity.standDescription = standModel.description ?? ""
        return entity
    }
    func mapStandHistoryModelToStandHistoryEntity(historyModel: StandHistoryModel, entity: StandHistoryEntity)
    -> StandHistoryEntity
    {
        entity.id = Int32(historyModel.id)
        entity.name = historyModel.name
        entity.standHistoryDescription = historyModel.description
        entity.basalArea = historyModel.basalArea
        entity.capturedAt = historyModel.capturedAt
        entity.concaveAreaHectare = historyModel.concaveAreaHectare
        entity.concaveAreaMeter = historyModel.concaveAreaMeter
        entity.convexAreaHectare = historyModel.convexAreaHectare
        entity.convexAreaMeter = historyModel.concaveAreaMeter
        entity.meanDbh = historyModel.meanDbh
        entity.meanDistance = historyModel.meanDistance
        return entity
    }
    func mapTreeModelToTreeEntity(treeModel: TreeModel, entity: TreeEntity)
    -> TreeEntity
    {
        entity.id = Int32(treeModel.id)
        entity.latitude = treeModel.latitude
        entity.longitude = treeModel.longitude
        entity.x = treeModel.x
        entity.y = treeModel.y
        entity.treeDescription = treeModel.description
        entity.deletedAt = treeModel.deletedAt
        return entity
    }
    func mapCaptureModelToCaptureEntity(captureModel: TreeCaptureModel, entity: TreeCaptureEntity)
    -> TreeCaptureEntity
    {
        entity.id = Int32(captureModel.id)
        entity.idTree = Int32(captureModel.idTree)
        entity.basalArea = captureModel.basalArea
        entity.capturedAt = captureModel.capturedAt
        entity.dbh = captureModel.dbh
        return entity
    }
    func mapDiameterModelToDiameterEntity(diameterModel: DiameterModel, entity: DiameterEntity)
    -> DiameterEntity
    {
        entity.id = Int32(diameterModel.id)
        entity.idTreeCapture = Int32(diameterModel.idTreeCapture)
        entity.diameter = diameterModel.diameter
        entity.height = diameterModel.height
        return entity
    }
    
    // MARK: UTILS
    private func createMissingEntityPublisher(message: String) -> AnyPublisher<Bool, Error> {
        return Fail(error: CoreDataError.entityNotFound(message))
            .mapError { error in
                CoreDataError.entityNotFound(message)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: DEV UTILS
    
    func printContent() {
        localStandEntities.forEach { entity in
            print("STAND : \(entity.id)")
            if let histories = entity.histories as? Set<StandHistoryEntity> {
                print("  Histories : \(histories.count)")
            }
            if let trees = entity.trees as? Set<TreeEntity> {
                print("  Trees : \(trees.count)")
                for tree in trees {
                    if let captures = tree.captures as? Set<TreeCaptureEntity> {
                        print("    Captures : \(captures.count)")
                        for capture in captures {
                            if let diameters = capture.diameters as? Set<DiameterEntity> {
                                print("      Diameters : \(diameters.count)")
                            }
                        }
                    }
                }
            }
        }
    }
}

