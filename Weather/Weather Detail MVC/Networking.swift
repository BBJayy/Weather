//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation


class Networking: NetworkingService {
  
  func getRequest(_ url: URL, parameters: [String : String], responce: @escaping (Data?, Error?) -> ()) {
    let urlComp = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
    
    var items = [URLQueryItem]()
    
    for (key,value) in parameters {
      items.append(URLQueryItem(name: key, value: value))
    }
    
    items = items.filter{!$0.name.isEmpty}
    
    if !items.isEmpty {
      urlComp.queryItems = items
    }
    
    var urlRequest = URLRequest(url: urlComp.url!)
    urlRequest.httpMethod = "GET"
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
      responce(data, error)
    }
    task.resume()

  }
  
  
  
}
