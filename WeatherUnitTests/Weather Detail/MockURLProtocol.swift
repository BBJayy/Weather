//
//  MockURLProtocol.swift
//  WeatherUnitTests
//
//  Created by Рома Сорока on 08.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
        
    }
    
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
