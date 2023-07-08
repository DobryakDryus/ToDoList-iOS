//
//  ServerCache.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 08.07.2023.
//

import UIKit

class ServerCache: Codable {
    var status: String = "ok"
    var list: [ServerToDoItem] = []
    var revision: Int = 0
    
    
    // MARK: - from server items to app items
    
    private static func serverToDoItemToAppItem(withElem elem: ServerToDoItem) -> ToDoItem {
        let id = elem.id
        let text = elem.text
        var importance: Importance
        switch elem.importance {
            case "low": importance = .unimportant
            case "important": importance = .important
            default: importance = .common
        }
        let completeStatus = elem.done
        var deadline: Date?
        if let deadlineInt = elem.deadline {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
        }
        let createdAt = Date(timeIntervalSince1970: TimeInterval(elem.createdAt))
        var changedAt: Date?
        if let changedAtInt = elem.changedAt {
            changedAt = Date(timeIntervalSince1970: TimeInterval(changedAtInt))
        }
        let item = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, completeStatus: completeStatus, createdAt: createdAt, changedAt: changedAt)
        return item
    }
    
    static func decodeServerItemToAppItem(with data: Data) throws -> ([ToDoItem], Int) {
        var appList: [ToDoItem] = []
        let serverList = try JSONDecoder().decode(self, from: data)
        
        for elem in serverList.list {
            appList.append(ServerCache.serverToDoItemToAppItem(withElem: elem))
        }

        return (appList, serverList.revision)
    }
    
    static func decodeOneElement(with data: Data) throws -> (ToDoItem, Int) {
        let responce = try JSONDecoder().decode(GetElementResponce.self, from: data)
        let item = serverToDoItemToAppItem(withElem: responce.element)
        return (item, responce.revision)
    }
    
    
    // MARK: - from app items to server items
    
    private static func appToDoItemToServerItem(withItem item: ToDoItem) -> ServerToDoItem {
        let id = item.id
        let text = item.text
        let done = item.completeStatus
        var importance: String
        switch item.importance {
            case .important: importance = "important"
            case .unimportant: importance = "low"
            case .common: importance = "basic"
        }
        let color = "#FFFFFF"
        var deadline: Int?
        if let deadlineDate = item.deadline {
            deadline = Int(deadlineDate.timeIntervalSince1970)
        }
        let createdAt = Int(item.createdAt.timeIntervalSince1970)
        let changedAt = Int(item.changedAt?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        
        let deviceUpdatedBy = "iPod 7th generation"
        
        let elem = ServerToDoItem(id: id, text: text, importance: importance, deadline: deadline, done: done, color: color, createdAt: createdAt, changedAt: changedAt, lastUpdatedBy: deviceUpdatedBy)
        
        return elem
        
    }
    
    private static func parseAppListToServerList(with items: [ToDoItem]) -> [ServerToDoItem] {
        var appList: [ServerToDoItem] = []
        
        for item in items {
            appList.append(appToDoItemToServerItem(withItem: item))
        }

        return appList
    }
    
    static func encodeAppListToServerList(with list: [ToDoItem]) throws -> Data {
        let toEncode = UpdateServerListResponce(status: "ok", list: self.parseAppListToServerList(with: list))
        
        let encodedList = try JSONEncoder().encode(toEncode)
        
        return encodedList
    }
    
    static func encodeOneElement(with item: ToDoItem) throws -> Data {
        let elem = self.appToDoItemToServerItem(withItem: item)
        let toEncode = AddElementResponce(status: "ok", element: elem)
        let data = try JSONEncoder().encode(toEncode)
        return data
    }
}

// MARK: - structures to be encoded

struct UpdateServerListResponce: Codable {
    var status: String
    var list: [ServerToDoItem]
}

struct AddElementResponce: Codable {
    var status: String
    var element: ServerToDoItem
}

struct GetElementResponce: Codable {
    var status: String
    var element: ServerToDoItem
    var revision: Int
}
