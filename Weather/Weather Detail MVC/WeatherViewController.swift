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
  
  var model = WeatherModel(networkingService: OpenWeatherNetworking())
  
  var plussSignAvailable = true
  var showingDay = 0
  
  var city: WeatherCity? {
    didSet {
      navigationItem.title = city?.name
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if !plussSignAvailable {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    model.get5DayWeatherForecast(city: city!) { (responce: Response<WeatherResponce>) in
      switch responce {
      case .success(let weather):
        self.updateUIandCityFor(day: self.showingDay, from: weather)
      case Response.error(let err):
        print(err.localizedDescription)
        self.currentWeatherTempLabel.text = "Error occured"
        self.detailLabels.forEach { $0.text = "..." }
      }
    }
  }

  @objc func futureViewTapped(sender: UIGestureRecognizer) {
    showingDay = sender.view!.tag
    futureViews.forEach { $0.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1411764706, blue: 0.1529411765, alpha: 1) }
    futureViews[showingDay].backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4784313725, blue: 0, alpha: 1)
    if let responce = model.weatherResponce {
      updateUIandCityFor(day: showingDay, from: responce)
    }
  }
  
  func updateUIandCityFor(day: Int, from responce: WeatherResponce) {
    let i = responce.timeStamps.count / 5
    
    currentWeatherImage.image = responce.timeStamps[day * i].weatherImage
    city?.weatherImage = responce.timeStamps[0].weatherImage
    currentWeatherTempLabel.text = "\(Int(responce.timeStamps[day * i].temp - 273.15)) ℃"
    city?.temperature = Int16(responce.timeStamps[day * i].temp - 273.15)
    detailLabels[0].text = "\(responce.timeStamps[day * i].windSpeed)m/s"
    detailLabels[1].text = String(responce.timeStamps[day * i].percipation) + "mm"
    detailLabels[2].text = "\(responce.timeStamps[day * i].humidity)%"
    
    for i in 0..<5 {
      futureWeatherImages[i].image = responce.timeStamps[0].weatherImage
      futureTempLabels[i].text = "\(Int(responce.timeStamps[i*8].temp - 273.15)) ℃"
      
      let date = responce.timeStamps[i*8].date
      let format = "EEEE"
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      
      futureDayNames[i].text = dateFormatter.string(from: date)
    }

  }
  
}
