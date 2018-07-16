 //
//  AppDelegate.swift
//  Weather
//
//  Created by Рома Сорока on 25.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit
import CoreData
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    UIApplication.shared.statusBarStyle = .lightContent
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    print(urls[urls.count-1] as URL)
    return true
  }


  // MARK: - Core Data stack
  
  lazy var applicationDocumentDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let url = urls[urls.count - 1]
    return url
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let url = applicationDocumentDirectory.appendingPathComponent("DataModel.sqlite")

    if !FileManager.default.fileExists(atPath: url.path) {
      let sourceSqliteURLs = [Bundle.main.url(forResource: "DataModel", withExtension: "sqlite")!, Bundle.main.url(forResource: "DataModel", withExtension: "sqlite-wal")!, Bundle.main.url(forResource: "DataModel", withExtension: "sqlite-shm")!]

      let destSqliteURLs = [applicationDocumentDirectory.appendingPathComponent("DataModel.sqlite"), applicationDocumentDirectory.appendingPathComponent("DataModel.sqlite-wal"), applicationDocumentDirectory.appendingPathComponent("DataModel.sqlite-shm")]

      var error:NSError? = nil
      for index in 0..<sourceSqliteURLs.count {
        try! FileManager.default.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
      }

    }
    
    let container = NSPersistentContainer(name: "DataModel")
    let document = NSPersistentStoreDescription(url: applicationDocumentDirectory.appendingPathComponent("DataModel.sqlite"))
    container.persistentStoreDescriptions = [document]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
}

