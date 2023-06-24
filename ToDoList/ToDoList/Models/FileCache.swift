//
//  FileCache.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 20.06.2023.
//

import Foundation

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
    
    // Help function that returns File URL to save
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

