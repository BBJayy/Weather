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
private let reuseIdentifier = "SavedCityCell"
private let toWeatherSegueIdentifier = "checkoutCityWeather"
private let toAddVCSegueIdentifier = "addNewCity"

class HomeCollectionViewController: UICollectionViewController {
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  private var model = HomeModel()
  
  
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLocationManager()
    
    flowLayout?.itemSize = UICollectionViewFlowLayoutAutomaticSize
    flowLayout?.estimatedItemSize = CGSize(width: 100, height: 120)
    
  }
  
  private var flowLayout: UICollectionViewFlowLayout? {
    return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  
  @IBAction func appendToHomeVC(segue: UIStoryboardSegue) {
    let weatherVC = segue.source as! WeatherViewController
    model.savedCities.append(weatherVC.city!)
    collectionView?.reloadData()
  }
  
  @IBAction func saveToHomeVC(segue: UIStoryboardSegue) {
    let weatherVC = segue.source as! WeatherViewController
    let updatedCity = weatherVC.city!
    let i = model.savedCities.index { $0.name == updatedCity.name }
    if i != nil {
      model.savedCities[i!] = updatedCity
      collectionView?.reloadData()
    }
  }
  
  @IBAction func myLocationButtonClicked(_ sender: Any) {
    locationManager.startUpdatingLocation()
    spinner.startAnimating()
  }
  
  //MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toWeatherSegueIdentifier {
      guard let destination = segue.destination as? WeatherViewController else { fatalError("can't cast to WeatherViewController") }
      destination.city = model.cityToChekout
      
    }
  }
  
}

//MARK: CollectionView stuff

extension HomeCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.savedCities.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
    let city = model.savedCities[indexPath.row]
    cell.cityNameLabel.text = city.name
    cell.temperaatureLabel.text = (city.temperature != nil) ? "\(city.temperature!) ℃" : "? ℃"
    cell.weatherImage.image = city.weatherImage ?? UIImage(named: "dunno")
    cell.layer.cornerRadius = cellCornerRaadius
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    model.cityToChekout = model.savedCities[indexPath.row]
    performSegue(withIdentifier: toWeatherSegueIdentifier, sender: nil)
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

//MARK: LocationManager stuff

extension HomeCollectionViewController: CLLocationManagerDelegate {
  
  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  private func presentAlert() {
    let aller = UIAlertController(title: "Error", message: "Check your internet connection", preferredStyle: .alert)
    present(aller, animated: true, completion: nil)
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lng = location.coordinate.longitude
      
      //print("long:" + String(longtitude) + ", lat: " + String(latitude))
      self.model.cityWith(latitude: lat, longitude: lng) { (city) in
        self.spinner.stopAnimating()
        if city == nil {
          self.presentAlert()
          return
        } else {
          self.model.cityToChekout = city!
          self.performSegue(withIdentifier: toWeatherSegueIdentifier, sender: nil)
        }
      }
      
    }
  }
  
}
