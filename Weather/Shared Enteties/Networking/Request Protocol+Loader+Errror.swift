//
//  APIRequest.swift
//  Weather
//
//  Created by Рома Сорока on 03.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case invalidCoordinate
    case invalidURL
    case unknown
}

protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

class APIRequestLoader<T: APIRequest> {
    let apiRequest: T
    let urlSession: URLSession
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    func loadAPIRequest(requestData: T.RequestDataType,
                        completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else { return completionHandler(nil, error) }
                do {
                    let parsedResponse = try self.apiRequest.parseResponse(data: data)
                    completionHandler(parsedResponse, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }.resume()
        } catch { return completionHandler(nil, error) }
    }
}
