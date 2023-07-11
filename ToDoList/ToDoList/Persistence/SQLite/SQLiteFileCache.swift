//
//  SQLiteFileCache.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 11.07.2023.
//

import UIKit
import SQLite

final class SQLiteFileCache {
    
    // MARK: - static internal functions

    static func createDataBaseSQL() -> Connection? {
        do {
            let url = try getFileURL(withPath: self.DBPath)
            let db = try Connection("\(url.absoluteString)")
                
            try db.run(todoitem.create(ifNotExists: true) { newTable in
                newTable.column(DBFields.id, primaryKey: true)
                newTable.column(DBFields.text)
                newTable.column(DBFields.importance, defaultValue: "common")
                newTable.column(DBFields.deadline, defaultValue: nil)
                newTable.column(DBFields.completeStatus, defaultValue: false)
                newTable.column(DBFields.createdAt)
                newTable.column(DBFields.changedAt)
            })
                
            return db
        }
        catch {
            print("error")
            return nil
        }
    }
    
    static func upsertItemInSQLite(dbConnection: Connection?, item: ToDoItem) {
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        
        let insert = todoitem.insert(or: .replace ,
                                     DBFields.id <- item.id,
                                     DBFields.text <- item.text,
                                     DBFields.importance <- item.importance.rawValue,
                                     DBFields.deadline <- item.deadline != nil ? Int(item.deadline?.timeIntervalSince1970 ?? 0) : nil,
                                     DBFields.completeStatus <- item.completeStatus,
                                     DBFields.createdAt <- Int(item.createdAt.timeIntervalSince1970),
                                     DBFields.changedAt <- item.changedAt != nil ? Int(item.changedAt?.timeIntervalSince1970 ?? 0) : nil
                                     )
        do {
            try db.run(insert)
        } catch {
            print("Cannot to insert or replace item")
        }
    }
    
    static func deleteItemInSQLite(dbConnection: Connection?, id: String) {
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        do {
            let toDelete = todoitem.filter(DBFields.id == id)
            try db.run(toDelete.delete())
        } catch {
            print("Cannot to delete item")
        }
    }
    
    static func getListFromSQLiteDB(dbConnection: Connection?) -> [ToDoItem] {
        
        var list: [ToDoItem] = []
        
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return list
        }
        
        do {
            for item in try db.prepare(todoitem) {
                
                var importance: Importance
                    switch item[DBFields.importance] {
                    case "important": importance = .important
                    case "unimportant": importance = .unimportant
                    default: importance = .common
                }
                
                var deadline: Date?
                if let deadlineInt = item[DBFields.deadline] {
                    deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
                }
                
                var changedAt: Date?
                if let changedAtInt = item[DBFields.changedAt] {
                    changedAt = Date(timeIntervalSince1970: TimeInterval(changedAtInt))
                }
                
                
                let item = ToDoItem(id: item[DBFields.id],
                                    text: item[DBFields.text],
                                    importance: importance,
                                    deadline: deadline,
                                    completeStatus: item[DBFields.completeStatus],
                                    createdAt: Date(timeIntervalSince1970: TimeInterval(item[DBFields.createdAt])),
                                    changedAt: changedAt)
                list.append(item)
            }
        } catch {
            print("Error with handling items in db")
        }
        return list
    }
    
    // MARK: - private variables and methods
    
    private static let DBPath = "ToDoListSQLiteDB.sqlite3"
    
    private static let todoitem = Table("todoitem")
    
    private enum DBFields {
        static let id = Expression<String>("id")
        static let text = Expression<String>("text")
        static let importance = Expression<String>("importance")
        static let deadline = Expression<Int?>("deadline")
        static let completeStatus = Expression<Bool>("completeStatus")
        static let createdAt = Expression<Int>("createdAt")
        static let changedAt = Expression<Int?>("changedAt")
    }
    
    private enum DBErrors: Error {
        case invalidURL
    }
    
    
    private static func getFileURL(withPath: String) throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DBErrors.invalidURL
        }
        let pathWithFilename = documentDirectory.appendingPathComponent(withPath)
        return pathWithFilename
    }
    
    
    
}
