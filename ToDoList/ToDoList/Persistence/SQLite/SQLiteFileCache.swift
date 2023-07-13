//
//  SQLiteFileCache.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 11.07.2023.
//

import UIKit
import SQLite

fileprivate enum DBFields {
    static let id = Expression<String>("id")
    static let text = Expression<String>("text")
    static let importance = Expression<String>("importance")
    static let deadline = Expression<Int?>("deadline")
    static let completeStatus = Expression<Bool>("completeStatus")
    static let createdAt = Expression<Int>("createdAt")
    static let changedAt = Expression<Int?>("changedAt")
}

extension ToDoItem {
    // MARK: - extension to work with db Item
   var sqlReplaceStatement: String {
       var replaceStatement = "REPLACE INTO \"todoitem\" "
       let columns = [DBFields.id.description,  DBFields.text.description, DBFields.importance.description, DBFields.deadline.description, DBFields.completeStatus.description, DBFields.createdAt.description, DBFields.changedAt.description]
       
       var deadlineStr = "NULL"
       if let deadline = self.deadline {
           deadlineStr = String(Int(deadline.timeIntervalSince1970))
       }
       
       var changedAtStr = "NULL"
       if let changedAt = self.changedAt {
           changedAtStr = String(Int(changedAt.timeIntervalSince1970))
       }
    
       let values = ["\'\(self.id)\'", "\'\(self.text)\'", "\'\(self.importance.rawValue)\'", deadlineStr, String(self.completeStatus ? 1 : 0), String(Int(self.createdAt.timeIntervalSince1970)), changedAtStr ]
       
       replaceStatement.append("(\(columns.joined(separator: ", ")))")
       replaceStatement.append(" VALUES (\(values.joined(separator: ", ")))")
       
       return replaceStatement
   }
    
    static func parseFromDBRow(dbItem: Row) -> ToDoItem {
        var importance: Importance
            switch dbItem[DBFields.importance] {
            case "important": importance = .important
            case "unimportant": importance = .unimportant
            default: importance = .common
        }
        
        var deadline: Date?
        if let deadlineInt = dbItem[DBFields.deadline] {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
        }
        
        var changedAt: Date?
        if let changedAtInt = dbItem[DBFields.changedAt] {
            changedAt = Date(timeIntervalSince1970: TimeInterval(changedAtInt))
        }
        
        let item = ToDoItem(id: dbItem[DBFields.id],
                            text: dbItem[DBFields.text],
                            importance: importance,
                            deadline: deadline,
                            completeStatus: dbItem[DBFields.completeStatus],
                            createdAt: Date(timeIntervalSince1970: TimeInterval(dbItem[DBFields.createdAt])),
                            changedAt: changedAt)
        return item
    }
    
}

extension FileCache {
    // MARK: - task without a star
    func createDataBaseSQL() -> Connection? {
        do {
            let url = try FileCache.getFileURL(withPath: FileCache.DBPath)
            let db = try Connection("\(url.absoluteString)")
                
            try db.run(FileCache.todoitem.create(ifNotExists: true) { newTable in
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
    
    func loadListFromSQLiteDB(dbConnection: Connection?) {
        
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        
        do {
            for item in try db.prepare(FileCache.todoitem) {
                
                let toDoItem = ToDoItem.parseFromDBRow(dbItem: item)
                self.addItemToList(item: toDoItem)
            }
        } catch {
            print("Error with handling items in db")
        }
        return
    }
    
    func saveToSQLiteDB(dbConnection: Connection?) {
        
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        
        do {
            try db.run(FileCache.todoitem.delete())
            for item in self.listToDoItem {
                try db.run(item.sqlReplaceStatement)
            }
        } catch {
            print("Failed operation. \(error)")
        }
        
    }
    // MARK: - task with star
    
    /// Function that inserts a row or update on conflict ID
    func upsertItemInSQLite(dbConnection: Connection?, item: ToDoItem) {
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        
        let upsert = FileCache.todoitem.upsert(DBFields.id <- item.id,
                                     DBFields.text <- item.text,
                                     DBFields.importance <- item.importance.rawValue,
                                     DBFields.deadline <- item.deadline != nil ? Int(item.deadline?.timeIntervalSince1970 ?? 0) : nil,
                                     DBFields.completeStatus <- item.completeStatus,
                                     DBFields.createdAt <- Int(item.createdAt.timeIntervalSince1970),
                                     DBFields.changedAt <- item.changedAt != nil ? Int(item.changedAt?.timeIntervalSince1970 ?? 0) : nil, onConflictOf: DBFields.id
                                     )
        do {
            try db.run(upsert)
        } catch {
            print("Cannot to insert or replace item")
        }
    }
    
    
    func deleteItemInSQLite(dbConnection: Connection?, id: String) {
        guard let db = dbConnection else {
            print("Unable to connect to database")
            return
        }
        do {
            let toDelete = FileCache.todoitem.filter(DBFields.id == id)
            try db.run(toDelete.delete())
        } catch {
            print("Cannot to delete item")
        }
    }
    
    // MARK: - private variables and methods
    
    private static let DBPath = "ToDoListSQLiteDB.sqlite3"
    
    private static let todoitem = Table("todoitem")
    
    /// Function need to convert StringPath of DataBase to URL
    private static func getFileURL(withPath: String) throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DBErrors.invalidURL
        }
        let pathWithFilename = documentDirectory.appendingPathComponent(withPath)
        return pathWithFilename
    }
    
    private enum DBErrors: Error {
        case invalidURL
    }
    
}
