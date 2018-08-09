//
//  HomeModel.swift
//  Weather
//
//  Created by Рома Сорока on 10.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

protocol WeatherCityStorageService {
    func append(city: WeatherCity)
    func fetchCities() -> [WeatherCity]
}

class HomeModel {
    
    private let localStorage: WeatherCityStorageService
    private var mapper: MapperService?
    private var currentWeatherLoader: APIRequestLoader<CurrenWeatherRequest>?
    private let weatherDecoder = { () -> JSONDecoder in
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .secondsSince1970
        return dec
    }()
    
    var cityToChekout: WeatherCity?
    
    var savedCities = [WeatherCity]() {
        didSet {
            if let newCity = savedCities.last {
                localStorage.append(city: newCity)
            }
        }
    }
    
    init(storage: WeatherCityStorageService,
         networking: APIRequestLoader<CurrenWeatherRequest>) {
        self.localStorage = storage
        self.currentWeatherLoader = networking
        savedCities = localStorage.fetchCities()
    }
    
    
}

//MARK: Weather Networking

extension HomeModel {
    func fetchCitiesWeather(complition: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let dg = DispatchGroup()
            for city in self.savedCities {
                dg.enter()
                DispatchQueue.global(qos: .userInteractive).async {
                    self.currentWeatherLoader?.loadAPIRequest(requestData: city) {
                        (weatherCity, error) in
                        guard error == nil else {
                            print("Error getting weather for city \(city.name): \(error!)")
                            return
                        }
                        
                        city.temperature = Int16(weatherCity!.temp - 273.15)
                        city.weatherImage = weatherCity!.weatherImage
                        dg.leave()
                    }
                }
            }
            dg.notify(queue: DispatchQueue.main, execute: complition)
        }
        
    }
}

//MARK: Location

protocol MapperService {
    func getCityName(latitude: Double, longtitude: Double, responce: @escaping (Response<String>) -> ())
}

extension HomeModel {
    func set(mapper: MapperService) {
        self.mapper = mapper
    }
    
    func cityWith(latitude: Double, longitude: Double, complition: @escaping (WeatherCity?) -> Void ){
        mapper?.getCityName(latitude: latitude, longtitude: longitude) { (resp) in
            var city: WeatherCity? = nil
            switch resp {
            case .success(let name):
                city = WeatherCity(name: name, lat: Double(latitude), lng: Double(longitude), weatherImage: nil, temperature: nil)
                
            case .error(let err):
                print(err.localizedDescription)
                
            }
            complition(city)
        }
    }
}
