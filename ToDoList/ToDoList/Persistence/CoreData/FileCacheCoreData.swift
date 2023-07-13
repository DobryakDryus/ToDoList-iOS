//
//  FileCacheCoreData.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 12.07.2023.
//

import Foundation
import CoreData

public final class FileCacheCoreData {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(storeDescription.url?.absoluteString)
            }
            
        }
        
        return container
    }()
    
    
}
