//
//  SearchRouter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 13/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

protocol Routerable {
    func makeViewController() -> UIViewController
}

protocol SearchRouterProtocol: AnyObject {
    func navigateToWeekScene(model: WeatherSearchCityModel)
}

final class SearchRouter: Routerable {
    private var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func makeViewController() -> UIViewController {
        let presenter = SearchPresenter(router: self)
        let viewController = SearchViewController(presenter: presenter)
        return viewController
    }
}

extension SearchRouter: SearchRouterProtocol {
    func navigateToWeekScene(model: WeatherSearchCityModel) {
        
        let router = WeekdayRouter(navigation: navigation, search: model)
        let vc = router.makeViewController()
        navigation.pushViewController(vc, animated: true)
    }
}
