//
//  CityChooserTableViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

//
//{
//  "id": 519188,
//  "name": "Novinki",
//  "country": "RU",
//  "coord": {
//    "lon": 37.666668,
//    "lat": 55.683334
//  }
//
//
import UIKit

private let toWeatherCVIndentifier = "toWeatherVC"
private let reuseIdentifier = "CityCell"

class CityChooserTableViewController: UITableViewController {
  
  private var model = CityChooserModel()
  
  var selectedCellIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //model.setupDB()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if model.countries == nil {
      tableView.isScrollEnabled = false
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        self?.model.loadCitiesFromDB()
        DispatchQueue.main.async {
          self?.navigationItem.title = "Choose city"
          self?.tableView.reloadData()
          self?.tableView.isScrollEnabled = true
        }
      }
    }
  }

  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    if model.countries == nil { return 0 }
    return model.cities == nil ? model.countries!.count : 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if model.countries == nil { return 0 }
    return model.numberOfRows(in: section)
    
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel?.text = model.city(at: indexPath).name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return model.cities == nil ? model.country(at: section).initials! : ""
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedCellIndexPath = indexPath
    tableView.deselectRow(at: indexPath, animated: true)
    
    return indexPath
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toWeatherCVIndentifier {
      guard let weatherVC = segue.destination as? WeatherViewController else { fatalError("can't cast weatherVC") }
      
      let city = model.city(at: selectedCellIndexPath!)
      weatherVC.city = WeatherCity(name: city.name!, lat: city.lat, lng: city.lng, weatherImage: nil, temperature: nil)
    }
    
  }
  
  //MARK: sectionIndexTitles
  //  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
  //    return sortedCountryInitials
  //  }
  
}

extension CityChooserTableViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    model.loadCitiesFromDB(containing: searchBar.text!)
    
    DispatchQueue.main.async {
      searchBar.resignFirstResponder()
      self.tableView.reloadData()
    }
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      model.loadCitiesFromDB()
      
      DispatchQueue.main.async { [weak self] in
        searchBar.resignFirstResponder()
        self?.tableView.reloadData()
      }
      
    }
  }
  
}

