//
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit


class WeatherViewController: UIViewController {
  @IBOutlet weak var currentWeatherImage: UIImageView!
  @IBOutlet weak var currentWeatherTempLabel: UILabel!
  @IBOutlet var detailImages: [UIImageView]!
  @IBOutlet var detailLabels: [UILabel]!
  @IBOutlet var futureWeatherImages: [UIImageView]!
  @IBOutlet var futureTempLabels: [UILabel]!
  @IBOutlet var futureDayNames: [UILabel]!
  
  var city: City? {
    didSet {
      navigationItem.title = city?.name
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
        self.currentWeatherImage.image = self.weatherResponce?.weatherImage(forListItem: 0)!
        self.currentWeatherTempLabel.text = "\(Int(self.weatherResponce!.list[0].main.temp - 273.15)) ℃"
        self.detailLabels[0].text = "\(self.weatherResponce!.list[0].wind.speed)m/s"
        self.detailLabels[1].text = String(self.weatherResponce?.list[0].rain?.percipation ?? 0) + "mm"
        self.detailLabels[2].text = "\(self.weatherResponce!.list[0].main.humidity)%"
        
        //weather forecast every 3 hours in 5 days, so 24/3 == 8 updates per day
        for i in 0..<5 {
          self.futureWeatherImages[i].image = self.weatherResponce?.weatherImage(forListItem: i*8)!
          self.futureTempLabels[i].text = "\(Int(self.weatherResponce!.list[i*8].main.temp - 273.15)) ℃"
          
          let date = self.weatherResponce?.list[i*8].dt
          let format = "EEEE"
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = format
          
          self.futureDayNames[i].text = dateFormatter.string(from: date!)
        }
        
//        print(self.weatherResponce!.list.count)
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
