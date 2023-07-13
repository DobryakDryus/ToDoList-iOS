//
//  ToDoItem+CoreDataClass.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 12.07.2023.
//
//

import Foundation
import CoreData

@objc(ToDoItemCoreData)
public class ToDoItemCoreData: NSManagedObject {
}

extension ToDoItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemCoreData> {
        return NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var importance: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var completeStatus: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var changedAt: Date?

}

