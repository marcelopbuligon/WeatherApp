//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 19/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

struct WeatherSearch: Codable {
    let consolidatedWeather: [WeatherModel]?
    let title: String
    let woeid: Int
    let lattLong: String
}

struct WeatherModel: Codable {
    let weatherStateAbbr: String
    let applicableDate: Date
    let theTemp: Double
    let minTemp: Double
    let maxTemp: Double
    let windSpeed: Double
    let humidity: Int
    let predictability: Int
}

protocol WeatherDataOutput: AnyObject {
    func didUpdateWeather(_ weatherData: [WeatherModel])
}

protocol WeatherSearchOutput: AnyObject {
    func didFindCities(_ citiesArray: [WeatherSearch])
}

protocol Loadable: AnyObject {
    func didFail(error:Error)
    func showLoading()
    func hideLoading()
}
