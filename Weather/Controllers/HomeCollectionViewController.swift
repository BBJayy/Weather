//
//  HomeCollectionViewController.swift
//  Weather
//
//  Created by Рома Сорока on 25.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit



private let reuseIdentifier = "SavedCityCell"
private let cellCornerRaadius: CGFloat = 7.0
private let addSegueIdentifier = "AddNewCity"

class HomeCollectionViewController: UICollectionViewController {
  
  var savedCities = [City]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let egypt = City(name: "Hurgada", country: "Egypt", weatherImageName: .sun, temperature: "22/16 ℃")
      //City(name: "Egypt", weatherImageName: .sun, temperature: "22/16 ℃")
    savedCities.append(egypt)
    
    let newYork = City(name: "New York", country: "USA", weatherImageName: .cloud, temperature: "5/10 ℃")
    
    savedCities.append(newYork)
    savedCities.append(newYork)
    savedCities.append(newYork)
    savedCities.append(newYork)
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Register cell classes
//    self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    // Do any additional setup after loading the view.
    flowLayout?.itemSize = UICollectionViewFlowLayoutAutomaticSize
    flowLayout?.estimatedItemSize = CGSize(width: 100, height: 120)

  }
  
  private var flowLayout: UICollectionViewFlowLayout? {
    return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using [segue destinationViewController].
   // Pass the selected object to the new view controller.
   }
   */
  
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
    cell.temperaatureLabel.text = city.temperature
    cell.weatherImage.image = UIImage(named: city.weatherImageName!.rawValue)
    cell.layer.cornerRadius = cellCornerRaadius
    
    return cell
  }
  
  
  @IBAction func backToSaved(segue: UIStoryboardSegue) {
    
  }
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  
}
