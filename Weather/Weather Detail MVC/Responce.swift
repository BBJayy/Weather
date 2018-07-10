//
//  Responce.swift
//  Weather
//
//  Created by Рома Сорока on 08.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

struct Responce<Entity: Decodable> {
  let entity: Entity?
  let error: Error?
  
  init(_ entity: Entity?, _ error: Error?) {
    self.entity = entity
    self.error = error
  }
}

