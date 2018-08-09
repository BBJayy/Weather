  //
//  WeatherViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var currentWeatherImage: UIImageView!
  @IBOutlet weak var currentWeatherTempLabel: UILabel!
  @IBOutlet var detailImages: [UIImageView]!
  @IBOutlet var detailLabels: [UILabel]!
  @IBOutlet weak var scrollView: UIScrollView!
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
  private lazy var refresher: UIRefreshControl! = {
    let refr = UIRefreshControl()
    refr.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
    refr.tintColor = .white
    return refr
  }()
  
    let model = WeatherModel(forecastService: APIRequestLoader<FiveDayForecastRequest>(apiRequest:
            FiveDayForecastRequest()
        )
    )
  
  var plussSignAvailable = true
  var showingDay = 0
  
  var city: WeatherCity? {
    didSet {
      navigationItem.title = city?.name
    }
  }

  @objc func refresh(_ refresher: UIRefreshControl) {
    DispatchQueue.global().async {
      self.requestWeatherData {
        refresher.endRefreshing()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.refreshControl = refresher
    if !plussSignAvailable {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  fileprivate func requestWeatherData(appandingAction: (() -> ())? = nil) {
    model.get5DayWeatherForecast(city: city!) { (responce: Response<WeatherResponce>) in
      switch responce {
      case .success(let weather):
        self.updateUIandCityFor(day: self.showingDay, from: weather)
      case Response.error(let err):
        print(err.localizedDescription)
        self.currentWeatherTempLabel.text = "Error occured"
        self.detailLabels.forEach { $0.text = "..." }
      }
      if appandingAction != nil { appandingAction!() }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    requestWeatherData()
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
    let i = 8 //number of 3 hour intervals in a day
    currentWeatherImage.image = responce.timeStamps[safe: day * i]?.weatherImage ?? #imageLiteral(resourceName: "dunno")
    city?.weatherImage = responce.timeStamps[safe: day * i]?.weatherImage
    
    let temp = responce.timeStamps[safe: day * i]?.temp
    currentWeatherTempLabel.text = temp != nil ? "\(Int(temp! - 273.15)) ℃" : "?"
    city?.temperature = temp != nil ? Int16(temp! - 273.15) : nil
    
    let windSpeed = responce.timeStamps[safe: day * i]?.windSpeed
    detailLabels[0].text = windSpeed != nil ? "\(windSpeed!)m/s" : "?"
    
    let percipation = responce.timeStamps[safe: day * i]?.percipation
    detailLabels[1].text = percipation != nil ? "\(percipation!)mm" : "?"
    
    let humidity = responce.timeStamps[safe: day * i]?.humidity
    detailLabels[2].text = humidity != nil ? "\(humidity!)%" : "?"
    
    for i in 0..<5 {
      futureWeatherImages[i].image = responce.timeStamps[safe: i*8]?.weatherImage ?? #imageLiteral(resourceName: "dunno")
      let temp = responce.timeStamps[safe: i*8]?.temp
      futureTempLabels[i].text = temp != nil ? "\(Int(temp! - 273.15)) ℃" : "?"
      
      if let date = responce.timeStamps[safe: i*8]?.date {
        let format = "EEEE"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dayName = dateFormatter.string(from: date)
        futureDayNames[i].text = dayName
      } else {
        futureDayNames[i].text = "?"
      }
    }

  }
  
}
