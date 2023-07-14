//
//  FileCacheCoreData.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 12.07.2023.
//

import Foundation
import CoreData


extension ToDoItem {
    
    static func parseFromCoreData(item: ToDoItemCoreData) -> ToDoItem {
        let id = item.id
        let text = item.text
        let deadline = item.deadline
        var importance: Importance
        switch item.importance {
            case "important": importance = .important
            case "unimportant": importance = .unimportant
            default: importance = .common
        }
        let completeStatus = item.completeStatus
        let createdAt = item.createdAt
        let changedAt = item.changedAt
        
        let toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, completeStatus: completeStatus, createdAt: createdAt, changedAt: changedAt)
        
        return toDoItem
    }
}

public final class FileCacheCoreData {
    // MARK: - basic functions
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("\(error)")
            }
        }
    }
    
    func loadFromCoreData() -> [ToDoItem] {
        var loadedList = [ToDoItem]()
        do {
        let fetchItems = try persistentContainer.viewContext.fetch(ToDoItemCoreData.fetchRequest())
        
        for item in fetchItems {
            loadedList.append(ToDoItem.parseFromCoreData(item: item))
        }
    
        } catch {
            print("\(error)")
        }
        return loadedList
    }
    
    func saveToCoreData(list: [ToDoItem]) {
        let fetchRequest: NSFetchRequest <ToDoItemCoreData> = ToDoItemCoreData.fetchRequest()
        
        do {
            let objects = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in objects {
                persistentContainer.viewContext.delete(object)
                saveContext()
            }
            
            for item in list {
                insertInCoreData(item: item)
            }
            
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: - with star
    
    func insertInCoreData(item: ToDoItem) {
        let newItem = ToDoItemCoreData(context: persistentContainer.viewContext)
        newItem.id = item.id
        newItem.text = item.text
        newItem.importance = item.importance.rawValue
        newItem.deadline = item.deadline
        newItem.changedAt = item.changedAt
        newItem.createdAt = item.createdAt
        newItem.completeStatus = item.completeStatus
        
        saveContext()
    }
    
    func updateInCoreData(item: ToDoItem) {
        let fetchRequest: NSFetchRequest<ToDoItemCoreData> = ToDoItemCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        fetchRequest.fetchLimit = 1
        
        do {
            let itemToUpdate = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if let toUpdate = itemToUpdate.first {
                toUpdate.text = item.text
                toUpdate.importance = item.importance.rawValue
                toUpdate.deadline = item.deadline
                toUpdate.changedAt = item.changedAt
                toUpdate.createdAt = item.createdAt
                toUpdate.completeStatus = item.completeStatus
            }
            saveContext()
            
        } catch {
            print("\(error)")
        }
    }
    
    func deleteFromCoreData(itemID: String) {
        let fetchRequest: NSFetchRequest<ToDoItemCoreData> = ToDoItemCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", itemID)
        fetchRequest.fetchLimit = 1
        
        do {
            let itemToDelete = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if let toDelete = itemToDelete.first {
                persistentContainer.viewContext.delete(toDelete)
                saveContext()
            }
        } catch {
            print(error)
        }
    }
    
}
