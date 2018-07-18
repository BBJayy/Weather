//
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

class WeatherViewController: VCLLoggingViewController {
  @IBOutlet weak var currentWeatherImage: UIImageView!
  @IBOutlet weak var currentWeatherTempLabel: UILabel!
  @IBOutlet var detailImages: [UIImageView]!
  @IBOutlet var detailLabels: [UILabel]!
  @IBOutlet var futureViews: [UIView]! {
    didSet {
      for view in futureViews {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(futureViewTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
      }
    }
  }
  @IBOutlet var futureWeatherImages: [UIImageView]!
  @IBOutlet var futureTempLabels: [UILabel]!
  @IBOutlet var futureDayNames: [UILabel]!
  
  var model = WeatherModel(networkingService: Networking())
  
  var city: WeatherCity? {
    didSet {
      navigationItem.title = city?.name
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    model.get5DayWeatherForecast(city: city!) { (responce: Responce<WeatherResponce>) in
      
      if responce.error != nil {  print(responce.error!.localizedDescription) }
      
      self.updateUIandCityFor(day: 0, from: responce.entity)
    }
  }

  @objc func futureViewTapped(sender: UIGestureRecognizer) {
    let day = sender.view!.tag
    futureViews.forEach { $0.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1411764706, blue: 0.1529411765, alpha: 1) }
    futureViews[day].backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4784313725, blue: 0, alpha: 1)
    updateUIandCityFor(day: day, from: model.weatherResponce)
  }
  
  func updateUIandCityFor(day: Int, from responce: WeatherResponce?) {
    if let resp = responce {
      let i = resp.timeStamps.count / 5
      
      currentWeatherImage.image = resp.timeStamps[day * i].weatherImage
      city?.weatherImage = resp.timeStamps[0].weatherImage
      currentWeatherTempLabel.text = "\(Int(resp.timeStamps[day * i].temp - 273.15)) ℃"
      city?.temperature = Int16(resp.timeStamps[day * i].temp - 273.15)
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
