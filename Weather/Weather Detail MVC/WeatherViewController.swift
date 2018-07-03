//
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
  @IBOutlet weak var navBar: UINavigationBar? {
    didSet { navBar?.topItem?.title = city?.name }
  }
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
  
  var weatherModel = WeatherModel(networkingService: Networking())
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    weatherModel.get5DayWeatherForecast(city: city!) { (weatherResponce: WeatherResponce?) in
      guard weatherResponce != nil else { return }
      
      self.updateUIfor(day: 0, from: weatherResponce!)
    }
  }

  func updateUIfor(day: Int, from json: WeatherResponce) {
    let i = json.timeStamps.count / 5
    
    currentWeatherImage.image = json.timeStamps[day * i].weatherImage
    self.city?.weatherImage = json.timeStamps[0].weatherImage
    self.currentWeatherTempLabel.text = "\(Int(json.timeStamps[day * i].temp - 273.15)) ℃"
    self.city?.temperature = "\(Int(json.timeStamps[day * i].temp - 273.15)) ℃"
    self.detailLabels[0].text = "\(json.timeStamps[day * i].windSpeed)m/s"
    self.detailLabels[1].text = String(json.timeStamps[day * i].percipation) + "mm"
    self.detailLabels[2].text = "\(json.timeStamps[day * i].humidity)%"
    
    for i in 0..<5 {
      self.futureWeatherImages[i].image = json.timeStamps[0].weatherImage
      self.futureTempLabels[i].text = "\(Int(json.timeStamps[i*8].temp - 273.15)) ℃"
      
      let date = json.timeStamps[i*8].date
      let format = "EEEE"
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      
      self.futureDayNames[i].text = dateFormatter.string(from: date)
    }
  }
  
}
