//
//  DefaultNetworkService.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 06.07.2023.
//

import UIKit

final class DefaultNetworkingService: NetworkServiceProtocol {
    
    // MARK: - network enum
    
    enum NetworkService {
        enum NetworkErrors: Error {
            static let invalidURL = NSError(domain: "invalidData", code: 505)
            static let serverError = NSError(domain: "server error", code: 500)
            static let missingElement = NSError(domain: "missingElement", code: 404)
            static let noSync = NSError(domain: "no syncronized revision", code: 400)
            static let incorrectAuth = NSError(domain: "incorrect Authorization", code: 401)
            static let unknownError = NSError(domain: "unknownError", code: 3)
        }
        
        enum httpMethod {
            static let getMethod = "GET"
            static let postMethod = "POST"
            static let patchMethod = "PATCH"
            static let putMethod = "PUT"
            static let deleteMethod = "DELETE"
        }
        
        enum URLSuffix {
            static let getListURLSuffix = "/list"
        }
    }
    
    // MARK: - protocol methods

    
    static func getListFromServer() async throws -> [ToDoItem] {
        let authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix, withMethod: NetworkService.httpMethod.getMethod, revisionNeed: false)
        
        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: response)
        let (toDoItemList, syncRevision) = try ServerCache.decodeServerItemToAppItem(with: data)
        
        self.revision = syncRevision
        return toDoItemList
    }
    
    static func updateListOnServer(with list: [ToDoItem]) async throws -> [ToDoItem] {
        var authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix, withMethod: NetworkService.httpMethod.patchMethod)
        
        let encodedNewList = try ServerCache.encodeAppListToServerList(with: list)
        authorizedRequest.httpBody = encodedNewList
        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: response)
        let (toDoItemList, syncRevision) = try ServerCache.decodeServerItemToAppItem(with: data)
        
        self.revision = syncRevision
        return toDoItemList
    }
    
    static func getElementFromServer(withId: String) async throws -> ToDoItem {
        let authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix + "/\(withId)", withMethod: NetworkService.httpMethod.getMethod, revisionNeed: false)
        
        let (data, responce) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: responce)
        let (item, _) = try ServerCache.decodeOneElement(with: data)
        
        return item
    }
    
    static func addElementToList(item: ToDoItem) async throws -> ToDoItem {
        var authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix, withMethod: NetworkService.httpMethod.postMethod)
        
        let encodedItem = try ServerCache.encodeOneElement(with: item)
        authorizedRequest.httpBody = encodedItem
        
        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: response)
        let (addedElem, newRevision) = try ServerCache.decodeOneElement(with: data)
        
        self.revision = newRevision
        return addedElem
    }
    
    static func changeElementOnServer(item: ToDoItem) async throws -> ToDoItem {
        var authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix + "/\(item.id)", withMethod: NetworkService.httpMethod.putMethod)
        
        let encodedChangedItem = try ServerCache.encodeOneElement(with: item)
        authorizedRequest.httpBody = encodedChangedItem
        
        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: response)
        let (changedElem, newRevision) = try ServerCache.decodeOneElement(with: data)
        
        self.revision = newRevision
        return changedElem
    }
    
    static func deleteElementFromList(withId: String) async throws -> ToDoItem {
        let authorizedRequest = try createAuthorizedRequest(withSuffix: NetworkService.URLSuffix.getListURLSuffix + "/\(withId)", withMethod: NetworkService.httpMethod.deleteMethod)
        
        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        try handleErrors(with: response)
        let (deletedElem, newRevision) = try ServerCache.decodeOneElement(with: data)
        
        self.revision = newRevision
        return deletedElem
    }
    
    // MARK: - private methods and variables
    
    static private func handleErrors(with response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkService.NetworkErrors.unknownError
        }

        switch response.statusCode {
            case 401: throw NetworkService.NetworkErrors.incorrectAuth
            case 500: throw NetworkService.NetworkErrors.serverError
            case 400: throw NetworkService.NetworkErrors.noSync
            case 404: throw NetworkService.NetworkErrors.missingElement
            default: return
        }
    }
    
    static private func createAuthorizedRequest(withSuffix URLsuffix: String, withMethod httpMethod: String, revisionNeed: Bool = true) throws -> URLRequest {
        
        let url = URL(string: baseURL + URLsuffix)
        
        guard let url = url else {
            throw NetworkService.NetworkErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        if revisionNeed {
            request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        request.httpMethod = httpMethod
        
        return request
    }
    
    static var isDirty = false
    private static var revision: Int = 0
    private static let token = "Bearer wooable"
    private static let baseURL = "https://beta.mrdekk.ru/todobackend"
    
}
