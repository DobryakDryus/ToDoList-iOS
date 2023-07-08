//
//  URLSession+Extension.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 08.07.2023.
//

import UIKit

extension URLSession {
    
    enum URLError: Error {
        static let invalidData = NSError(domain: "invalidData", code: 322)
    }
    
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var currentDataTask: URLSessionDataTask?
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                currentDataTask = URLSession.shared.dataTask(with: urlRequest) { data, responce, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let responce = responce {
                        continuation.resume(returning: (data, responce))
                    } else {
                        continuation.resume(throwing: URLError.invalidData)
                    }
                 }
                currentDataTask?.resume()
            }
        } onCancel: { [weak currentDataTask] in
            currentDataTask?.cancel()
        }
    }
    
}
