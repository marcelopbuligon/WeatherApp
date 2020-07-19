//
//  DetailsRouter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 16/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class DetailsRouter: Routerable {
    private var navigation: UINavigationController
    private var weatherData: WeatherDataModel
    private var search: WeatherSearchCityModel
    
    init(navigation: UINavigationController, weatherData: WeatherDataModel, search: WeatherSearchCityModel) {
        self.navigation = navigation
        self.weatherData = weatherData
        self.search = search
    }
    
    func makeViewController() -> UIViewController {
        let presenter = DetailsPresenter(weatherData: weatherData, search: search)
        let viewController = DetailsViewController(presenter: presenter)
        return viewController
    }
}
