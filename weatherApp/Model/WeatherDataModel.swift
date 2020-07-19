//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 19/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

struct WeatherSearchCityModel: Codable {
    let consolidatedWeather: [WeatherDataModel]?
    let title: String
    let woeid: Int
    let lattLong: String
}

struct WeatherDataModel: Codable {
    let weatherStateAbbr: String
    let applicableDate: Date
    let theTemp: Double
    let minTemp: Double
    let maxTemp: Double
    let windSpeed: Double
    let humidity: Int
    let predictability: Int
}

protocol WeekdayDataServiceDelegate: AnyObject {
    func didUpdateWeather(_ weatherData: [WeatherDataModel])
    func didFail(error:Error)
}

protocol SearchServiceDelegate: AnyObject {
    func didFindCities(_ cities: [WeatherSearchCityModel])
    func didFail(error:Error)
}
