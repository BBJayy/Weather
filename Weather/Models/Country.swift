//
//  Country.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

struct Country: Hashable {
  let hashValue: Int
  let initials: String
  
  static var hashFactory = 0
  
  init(_ initials: String) {
    self.initials = initials
    hashValue = Country.hashFactory
    Country.hashFactory += 1
  }
}
