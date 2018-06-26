//
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

  var city: City? {
    didSet {
      navigationItem.title = city?.name
      navigationItem.prompt = city?.country
    }
  }
  let APP_ID = "4241061e2732492036c32da93c869d53"
  var weatherResponce: WeatherResponce?
  
  func getRequest(params: [String:String]) {
    
//    let urlComp = NSURLComponents(string: "http://api.openweathermap.org/data/2.5/weather")!
    
    let urlComp = NSURLComponents(string: "http://api.openweathermap.org/data/2.5/forecast")!

    
    var items = [URLQueryItem]()
    
    for (key,value) in params {
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
    
    let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      self.weatherResponce = try! decoder.decode(WeatherResponce.self, from: data!)
      
      DispatchQueue.main.async {
        print(response?.description)
        print("\n\n\n")
        print(error.debugDescription)
        print("\n\n\n")
        print(self.weatherResponce)
      }
    })
    task.resume()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getRequest(params: ["lat" : String(city!.lat), "lon" : String(city!.lng), "appid" : APP_ID])
    
  }

  
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
