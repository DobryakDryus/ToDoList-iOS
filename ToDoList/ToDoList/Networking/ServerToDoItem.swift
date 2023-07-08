//
//  ServerToDoItem.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 08.07.2023.
//

import UIKit

struct ServerToDoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let done: Bool
    let color: String?
    let createdAt: Int
    let changedAt: Int?
    let lastUpdatedBy: String
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: String,
         deadline: Int? = nil,
         done: Bool = false,
         color: String? = nil,
         createdAt: Int,
         changedAt: Int? = nil,
         lastUpdatedBy: String) {
            self.id = id
            self.text = text
            self.importance = importance
            self.deadline = deadline
            self.done = done
            self.color = color
            self.createdAt = createdAt
            self.changedAt = changedAt
            self.lastUpdatedBy = lastUpdatedBy
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}
