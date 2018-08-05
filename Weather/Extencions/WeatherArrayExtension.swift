//
//  ArrayExtension.swift
//  Weather
//
//  Created by Рома Сорока on 30.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

extension Array where Element == WeatherResponce.Weather {
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
