//
//  HomeCollectionViewController.swift
//  Weather
//
//  Created by Рома Сорока on 25.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit
import CoreLocation

private let cellCornerRaadius: CGFloat = 7.0
private let addSegueIdentifier = "AddNewCity"
private let reuseIdentifier = "SavedCityCell"
private let toWeatherIdentifier = "checkoutCityWeather"

class HomeCollectionViewController: UICollectionViewController, CLLocationManagerDelegate {
  
  let locationManager = CLLocationManager()
  
  var savedCities = [City]()
  var cityToChekout: City?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    
    
    let hurghada = City(name: "Hurghada", country: "Egypt", weatherImage: UIImage(named: "dunno")!, temperature: "? ℃", lat: 27.257896, lng: 33.811607)
    let newYork = City(name: "New York", country: "USA", weatherImage: UIImage(named: "dunno")!, temperature: "? ℃", lat: 40.712775, lng: -74.005973)
    savedCities.append(newYork)
    savedCities.append(hurghada)
    
    flowLayout?.itemSize = UICollectionViewFlowLayoutAutomaticSize
    flowLayout?.estimatedItemSize = CGSize(width: 100, height: 120)

  }
  
  private var flowLayout: UICollectionViewFlowLayout? {
    return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  //MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toWeatherIdentifier {
      guard let destination = segue.destination as? WeatherViewController else { fatalError("can't cast to WeatherViewController") }
      // Add below code to get address for touch coordinates.
      destination.city = cityToChekout
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return savedCities.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
    let city = savedCities[indexPath.row]
    cell.cityNameLabel.text = city.name
    cell.temperaatureLabel.text = city.temperature ?? "? ℃"
    cell.weatherImage.image = city.weatherImage ?? UIImage(named: "dunno")
    cell.layer.cornerRadius = cellCornerRaadius
    
    return cell
  }
  
  
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      let latitude = location.coordinate.latitude
      let longtitude = location.coordinate.longitude
      
      print("long:" + String(longtitude) + ", lat: " + String(latitude))
      
      let geoCoder = CLGeocoder()
      let location = CLLocation(latitude: latitude, longitude: longtitude)
      geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        
        let cityName = placeMark.subAdministrativeArea
        print(cityName)
        let countryName = placeMark.country
        print(countryName)
        
        
        self.cityToChekout = City(name: cityName!, country: countryName!, weatherImage: UIImage(named: "cloud")!, temperature: "4.0", lat: Float(latitude), lng: Float(longtitude))
        self.performSegue(withIdentifier: toWeatherIdentifier, sender: nil)
        
      })
//      let params : [String : String] = ["lat" : latitude, "lon" : longtitude, "appid" : APP_ID]
//
//      getWeatherData(url: WEATHER_URL, parameters: params)
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    cityToChekout = savedCities[indexPath.row]
    performSegue(withIdentifier: toWeatherIdentifier, sender: nil)
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  @IBAction func appendToHomeVC(segue: UIStoryboardSegue) {
    let weatherVC = segue.source as! WeatherViewController
    savedCities.append(weatherVC.city!)
    collectionView?.reloadData()
  }
  
  @IBAction func saveToHomeVC(segue: UIStoryboardSegue) {
    let weatherVC = segue.source as! WeatherViewController
    let updatedCity = weatherVC.city!
    let i = savedCities.index { $0.name == updatedCity.name }
    if i != nil {
      savedCities[i!] = updatedCity
    }
    collectionView?.reloadData()
  }
  
  @IBAction func myLocationButtonClicked(_ sender: Any) {
    locationManager.startUpdatingLocation()
  }
  
  
  
}
