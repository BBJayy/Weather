//
//  Responce.swift
//  Weather
//
//  Created by Рома Сорока on 08.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

enum Response<Entity: Decodable> {
  case success(Entity)
  case error(Error)
}
