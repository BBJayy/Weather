//
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit
import os.log

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
  
  var weatherModel = WeatherModel(networkingService: Networking())
  
  var city: City? {
    didSet {
      navigationItem.title = city?.name
    }
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    weatherModel.get5DayWeatherForecast(city: city!) { (responce: Responce<WeatherResponce>) in
      
      if responce.error != nil {  print(responce.error!.localizedDescription) }
      
      self.updateUIfor(day: 0, from: responce.entity)
    }
  }

  
  func updateUIfor(day: Int, from responce: WeatherResponce?) {
    if let resp = responce {
      let i = resp.timeStamps.count / 5
      
      currentWeatherImage.image = resp.timeStamps[day * i].weatherImage
      city?.weatherImage = resp.timeStamps[0].weatherImage
      currentWeatherTempLabel.text = "\(Int(resp.timeStamps[day * i].temp - 273.15)) ℃"
      city?.temperature = "\(Int(resp.timeStamps[day * i].temp - 273.15)) ℃"
      detailLabels[0].text = "\(resp.timeStamps[day * i].windSpeed)m/s"
      detailLabels[1].text = String(resp.timeStamps[day * i].percipation) + "mm"
      detailLabels[2].text = "\(resp.timeStamps[day * i].humidity)%"
      
      for i in 0..<5 {
        futureWeatherImages[i].image = resp.timeStamps[0].weatherImage
        futureTempLabels[i].text = "\(Int(resp.timeStamps[i*8].temp - 273.15)) ℃"
        
        let date = resp.timeStamps[i*8].date
        let format = "EEEE"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        futureDayNames[i].text = dateFormatter.string(from: date)
      }
    } else {
      currentWeatherTempLabel.text = "Error occured"
      detailLabels.forEach { $0.text = "..." }
    }
  }
  
}
