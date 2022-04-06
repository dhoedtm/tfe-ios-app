//
//  CoreDataVM.swift
//  tfe
//
//  Created by martin d'hoedt on 4/5/22.
//

import Foundation
import CoreData

enum CoreDataEntities : String {
    case StandEntity
    case StandHistoryEntity
    case TreeEntity
    case TreeCaptureEntity
    case DiameterEntity
}

class CoreDataService: ObservableObject {
    let manager = CoreDataManager.instance
    
    @Published var localStandEntities: [StandEntity] = []
    
    init() {
//        fetchStands()
    }
    
    func save() {
        manager.save()
        fetchStands()
    }
    
    func fetchStands() {
        let request = NSFetchRequest<StandEntity>(entityName: CoreDataEntities.StandEntity.rawValue)
        do {
            localStandEntities = try manager.context.fetch(request)
        } catch (let error) {
            print("[CoreDataVM][fetchStands] error : \(error)")
        }
    }
    func addStand(stand: StandModel) {
        updateOrCreateStandEntityFromModel(stand: stand)
        save()
    }
    func updateStand(entity: StandEntity, stand: StandModel) {
        updateOrCreateStandEntityFromModel(entity: entity, stand: stand)
        save()
    }
    func deleteStand(id: Int32) {
        guard let validEntity = getStandEntityById(id: id)
        else {
            print("[CoreDataVM][deleteStand] stand not found")
            return
        }
        manager.context.delete(validEntity)
        save()
    }
    
    func getStandEntityById(id: Int32) -> StandEntity? {
        return localStandEntities.first { entity in
            entity.id == id
        }
    }
    
    func addTreesToStand(id: Int32, trees: [TreeModel]) {
        guard let standEntity = getStandEntityById(id: id)
        else {
            print("[CoreDataVM][addTreesToStand] stand not found")
            return
        }
        for tree in trees {
            let treeEntity  = TreeEntity(context: manager.context)
            mapTreeModelToTreeEntity(tree: tree, entity: treeEntity)
            standEntity.addToTrees(treeEntity)
            treeEntity.stand = standEntity
        }
        save()
    }
    
    /// Updates the provided entity, or creates a new StandEntity in the container if none is provided
    func updateOrCreateStandEntityFromModel(entity: StandEntity? = nil, stand: StandModel) {
        let newLocalStand : StandEntity = {
            if let entity : StandEntity = entity {
                return entity
            }
            return StandEntity(context: manager.context)
        }()
        mapStandModelToStandEntity(stand: stand, entity: newLocalStand)
    }
    
    func mapTreeModelToTreeEntity(tree: TreeModel, entity: TreeEntity) {
        entity.id = Int32(tree.id)
        entity.latitude = tree.latitude
        entity.longitude = tree.longitude
        entity.treeDescription = tree.description
        entity.deletedAt = tree.deletedAt
    }
    func mapStandModelToStandEntity(stand: StandModel, entity: StandEntity) {
        entity.id = Int32(stand.id)
        entity.name = stand.name
        entity.treeCount = Int16(stand.treeCount)
        entity.basalArea = stand.basalArea
        entity.convexAreaMeter = stand.convexAreaMeter
        entity.convexAreaHectare = stand.convexAreaHectare
        entity.concaveAreaMeter = stand.concaveAreaMeter
        entity.concaveAreaHectare = stand.concaveAreaHectare
        entity.treeDensity = stand.treeDensity
        entity.meanDbh = stand.meanDbh
        entity.meanDistance = stand.meanDistance
        entity.capturedAt = stand.capturedAt
        entity.standDescription = stand.description ?? ""
    }
}

