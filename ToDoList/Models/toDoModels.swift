//
//  toDoModels.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 16.06.2023.
//

import Foundation

//
//  main.swift
//  DZ1
//

enum Importance: String {
    case important = "important"
    case unimportant = "unimportant"
    case common = "common"
}

struct ToDoItem {
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
            dect["importance"] = self.importance
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
        
        let item = ToDoItem.init(id: id, text: text, importance: importance, deadline: deadline, completeStatus: completeStatus, createdAt: createdAt, changedAt: changedAt)
        
        return item
    }
}

extension ToDoItem {
    // computed variable that generates csv string with pattern
    // "id;text;importance;deadline;completeStatus;createdAt;changedAt"
    var csv: String {
        var csvString = ""
        csvString.append(contentsOf: "\(self.id);")
//        if self.text.contains(";") {
//            csvString.append("\"")
//        }
        csvString.append(contentsOf: "\(self.text)")
//        if self.text.contains(";") {
//            csvString.append("\"")
//        }
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
    
   private static func concatToCsvComponents(with: String) -> [String] {
        let csvArray = Array(with)
        var csvComponents: [String] = []
        var indexComponent = 0, temp = ""
       csvArray.forEach { char in
//        for char in csvArray {
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
    // "id;text;importance;deadline;completeStatus;createdAt;changedAt"
    static func parse(csv: String) -> ToDoItem? {
        guard csv.filter({$0 == ";"}).count == 6 else {
            return nil
        }
        
        let csvComponents = concatToCsvComponents(with: csv)
        let text = csvComponents[1]
        let id: String? = csvComponents[0] != "" ? csvComponents[0] : nil
        guard let id = id,
              let completeStatus = Bool(csvComponents[4]),
              let createdAtDouble = Double(csvComponents[5]),
              text != ""  else {
                 return nil
              }
        
        let createdAt = Date(timeIntervalSince1970: createdAtDouble)
        var importance: Importance
        let importanceStr = csvComponents[2]
        switch importanceStr {
            case Importance.important.rawValue: importance = Importance.important
            case Importance.unimportant.rawValue: importance = Importance.unimportant
            default: importance = Importance.common
        }
        
        var deadline: Date?
        if let deadlineDouble = Double(csvComponents[3]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        
        var changedAt: Date?
        if let deadlineDouble = Double(csvComponents[6]) {
            changedAt = Date(timeIntervalSince1970: deadlineDouble)
        }
        
        let item = ToDoItem.init(id: id, text: text, importance: importance, deadline: deadline, completeStatus: completeStatus, createdAt: createdAt, changedAt: changedAt)
        
        return item
    }
}

final class FileCache {
    private(set) var listToDoItem: [ToDoItem]
    
    func addItemToList(item: ToDoItem) {
        guard let index = listToDoItem.firstIndex(where: { $0.id == item.id } ) else {
            listToDoItem.append(item)
            return
        }
        listToDoItem[index] = item
    }
    
    func removeFromList(id: String) {
        self.listToDoItem.removeAll { $0.id == id }
    }
    
    private func getFileURL(withPath: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let pathWithFilename = documentDirectory.appendingPathComponent(withPath)
        return pathWithFilename
    }
    
    func saveToFile(withPath: String = "ToDoList.json") {
        guard let fileURL = getFileURL(withPath: withPath) else {
            return
        }
        var jsonArr = Array<Any>()
        for item in self.listToDoItem {
            jsonArr.append(item.json)
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArr, options: .prettyPrinted) {
            
            do {
                try jsonData.write(to: fileURL)
                print("Успешно записан в файл!")
            } catch {
                print("Ошибка")
            }
        
        }
    }
    
    func saveToCsvFile(withPath: String = "ToDoList.csv") {
        guard let fileURL = getFileURL(withPath: withPath) else {
            return
        }
        var stringToSave = "id;text;importance;deadline;completeStatus;createdAt;changedAt\n"
        for (index, item) in self.listToDoItem.enumerated() {
            stringToSave.append(contentsOf: item.csv)
            if index != self.listToDoItem.count - 1 {
                stringToSave.append("\n")
            }
        }
        do {
            try stringToSave.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Ошибка")
        }
    }
    
    func loadFromFile(withPath: String) {
        let filePathURL = URL(fileURLWithPath: withPath)
        if let jsonData = try? Data(contentsOf: filePathURL) {
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] else {
                return
            }
            for item in json {
                if let itemToAdd = ToDoItem.parse(json: item) {
                    addItemToList(item: itemToAdd)
                }
            }
        }
    }
    
    func loadFromCsvFile(withPath: String) {
        let filePathURL = URL(fileURLWithPath: withPath)
        do {
            let pattern = "id;text;importance;deadline;completeStatus;createdAt;changedAt"
            let csvString = try String(contentsOf: filePathURL)
            let csvLines = csvString.split(separator: "\n").map { String($0) }
            guard csvLines.count > 1 , csvLines[0] == pattern else {
                return
            }
            for index in 1..<csvLines.count  {
                if let item = ToDoItem.parse(csv: csvLines[index]) {
                    addItemToList(item: item)
                }
            }
        } catch {
            print("Ошибка")
        }
    }
    
    init(list: [ToDoItem]) {
        self.listToDoItem = []
        for item in list {
            addItemToList(item: item)
        }
    }
    
}

//var dictJson: [String: Any]  = ["id": "4",
//                                "text": "String",
//                                "importance": "common",
//                                "completeStatus": true,
//                                "createdAt": 1234.0]
//
//let csvStr = "4;String;;;true;1234.0;"
//let item = ToDoItem.parse(csv: csvStr)
//print(item)
//let list = FileCache.init(list: [item!])
//
//
//list.loadFromCsvFile(withPath: "/Users/dobryak_drus/Documents/ToDoList.csv")
//print(list.listToDoItem)
    
