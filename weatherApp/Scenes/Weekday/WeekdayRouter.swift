//
//  WeekdayRouter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 14/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

protocol WeekdayRouterProtocol: AnyObject {
    func navigateToDatailsScene(weatherData: WeatherDataModel)
}

final class WeekdayRouter: Routerable {
    private var navigation: UINavigationController
    private var search: WeatherSearchCityModel
    
    init(navigation: UINavigationController, search: WeatherSearchCityModel) {
        self.navigation = navigation
        self.search = search
    }
    
    func makeViewController() -> UIViewController {
        let presenter = WeekdayPresenter(search: search, router: self)
        let viewController = WeekdayViewController(presenter: presenter)
        return viewController
    }
}

extension WeekdayRouter: WeekdayRouterProtocol {
    func navigateToDatailsScene(weatherData: WeatherDataModel) {
        let router = DetailsRouter(navigation: navigation, weatherData: weatherData, search: search)
        let vc = router.makeViewController()
        navigation.pushViewController(vc, animated: true)
    }
}
