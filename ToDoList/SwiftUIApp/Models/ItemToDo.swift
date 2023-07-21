//
//  ItemToDo.swift
//  SwiftUIApp
//
//  Created by Andrey Oleynik on 19.07.2023.
//

import Foundation


enum Importance: String {
    case important = "important"
    case unimportant = "unimportant"
    case common = "common"
}

struct ToDoItem: Identifiable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let completeStatus: Bool
    let createdAt: Date
    let changedAt: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = Importance.common,
         deadline: Date? = nil,
         completeStatus: Bool = false,
         createdAt: Date,
         changedAt: Date? = nil) {
            self.id = id
            self.text = text
            self.importance = importance
            self.deadline = deadline
            self.completeStatus = completeStatus
            self.createdAt = createdAt
            self.changedAt = changedAt
    }
}


extension ToDoItem {
    var json: Any {
        var dect: Dictionary<String, Any> = [:]
        dect["id"] = self.id
        dect["text"] = self.text
        if self.importance != Importance.common {
            dect["importance"] = self.importance.rawValue
        }
        if self.deadline != nil {
            dect["deadline"] = self.deadline?.timeIntervalSince1970
        }
        dect["completeStatus"] = self.completeStatus
        dect["createdAt"] = self.createdAt.timeIntervalSince1970
        if self.changedAt != nil {
            dect["changedAt"] = self.changedAt?.timeIntervalSince1970
        }
        return dect
    }
    
    static func parse(json: Any) -> ToDoItem? {
        guard let jsonDict = json as? [String: Any] else {
            return nil
        }
        
        guard let id = jsonDict["id"] as? String,
              let text = jsonDict["text"] as? String,
              let createdAtNumber = jsonDict["createdAt"] as? Double,
              let completeStatus = jsonDict["completeStatus"] as? Bool else {
                  return nil
              }
        
        let importanceStr = jsonDict["importance"] as? String
        var importance: Importance
        
        switch importanceStr {
            case Importance.important.rawValue: importance = Importance.important
            case Importance.unimportant.rawValue: importance = Importance.unimportant
            default: importance = Importance.common
        }
        
        var deadline: Date?
        if let deadlineNumber = jsonDict["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineNumber)
        }

        let createdAt = Date(timeIntervalSince1970: createdAtNumber)
        
        var changedAt: Date?
        if let changedAtNumber = jsonDict["changedAt"] as? Double {
            changedAt = Date(timeIntervalSince1970: changedAtNumber)
        }
        
        let item = ToDoItem.init(id: id,
                                 text: text,
                                 importance: importance,
                                 deadline: deadline,
                                 completeStatus: completeStatus,
                                 createdAt: createdAt,
                                 changedAt: changedAt)
        
        return item
    }
}

extension ToDoItem {
    // computed variable that generates csv string with pattern:
    // "id;text;importance;deadline;completeStatus;createdAt;changedAt"
    private enum Keys: Int {
        case id = 0
        case text = 1
        case importance = 2
        case deadline = 3
        case completeStatus = 4
        case createdAt = 5
        case changedAt = 6
    }
    
    var csv: String {
        var csvString = ""
        csvString.append(contentsOf: "\(self.id);")

        csvString.append(contentsOf: "\(self.text)")

        csvString.append(contentsOf: ";\(self.importance != Importance.common ? self.importance.rawValue : "");")
        if let deadlineStr = self.deadline {
            csvString.append(contentsOf: String(deadlineStr.timeIntervalSince1970))
        }
        csvString.append(contentsOf: ";\(self.completeStatus);")
        csvString.append(contentsOf: "\(self.createdAt.timeIntervalSince1970);")
        if let changedAtStr = self.changedAt {
            csvString.append(contentsOf: String(changedAtStr.timeIntervalSince1970))
        }
        return csvString
    }
    
    //Help function that splits csv string to components
   private static func concatToCsvComponents(with: String) -> [String] {
        let csvArray = Array(with)
        var csvComponents: [String] = []
        var indexComponent = 0, temp = ""
        csvArray.forEach { char in
            if char == ";" {
                csvComponents.append(temp)
                temp = ""
                indexComponent += 1
            } else {
                temp.append(char)
            }
        }
        csvComponents.append(temp)
        return csvComponents
    }
    
    // Separator: ";"
    // Pattern: "id;text;importance;deadline;completeStatus;createdAt;changedAt"
    static func parse(csv: String) -> ToDoItem? {
        guard csv.filter({$0 == ";"}).count == 6 else {
            return nil
        }
        
        let csvComponents = concatToCsvComponents(with: csv)
        let text = csvComponents[Keys.text.rawValue]
        let id: String? = csvComponents[Keys.id.rawValue] != "" ? csvComponents[Keys.id.rawValue] : nil
        guard let id = id,
              let completeStatus = Bool(csvComponents[Keys.completeStatus.rawValue]),
              let createdAtDouble = Double(csvComponents[Keys.createdAt.rawValue]),
              text != ""  else {
                 return nil
              }
        
        let createdAt = Date(timeIntervalSince1970: createdAtDouble)
        var importance: Importance
        let importanceStr = csvComponents[Keys.importance.rawValue]
        switch importanceStr {
            case Importance.important.rawValue: importance = Importance.important
            case Importance.unimportant.rawValue: importance = Importance.unimportant
            default: importance = Importance.common
        }
        
        var deadline: Date?
        if let deadlineDouble = Double(csvComponents[Keys.deadline.rawValue]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        
        var changedAt: Date?
        if let changedDouble = Double(csvComponents[Keys.changedAt.rawValue]) {
            changedAt = Date(timeIntervalSince1970: changedDouble)
        }
        
        let item = ToDoItem.init(id: id, text: text, importance: importance, deadline: deadline, completeStatus: completeStatus, createdAt: createdAt, changedAt: changedAt)
        
        return item
    }
}

