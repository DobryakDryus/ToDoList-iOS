//
//  NetworkingProtocol.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 06.07.2023.
//

import UIKit

protocol NetworkServiceProtocol {
    static func getListFromServer() async throws -> [ToDoItem]
    static func updateListOnServer(with list: [ToDoItem]) async throws -> [ToDoItem]
    static func getElementFromServer(withId: String) async throws -> ToDoItem
    static func addElementToList(item: ToDoItem) async throws -> ToDoItem
    static func changeElementOnServer(item: ToDoItem) async throws -> ToDoItem
    static func deleteElementFromList(withId: String) async throws -> ToDoItem
}
