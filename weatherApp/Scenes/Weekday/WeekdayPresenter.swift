//
//  WeekdayPresenter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 14/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

protocol WeekdayPresenterDelegate {
    func showAlert(message: String, buttonTitle: String)
    func setupNavigationTitle(_ title: String)
    func setupNavigationBackButton(_ title: String)
    func pullEndFreshing()
    func showLoading()
    func hideLoading()
    func reloadData()
}

final class WeekdayPresenter {
    
    private var view: WeekdayPresenterDelegate?
    private var service: WeekdayDataServiceProtocol
    private var router: WeekdayRouterProtocol
    private var search: WeatherSearchCityModel
    
    var dataSource: [WeatherDataModel] = []
    
    init(
        service: WeekdayDataServiceProtocol = WeekdayDataService(),
        search: WeatherSearchCityModel,
        router: WeekdayRouterProtocol
        
    ) {
        self.service = service
        self.router = router
        self.search = search
        
        self.service.delegate = self
    }
    
    func attachView(_ view: WeekdayPresenterDelegate) {
        setupWeatherService()
        view.setupNavigationBackButton(search.title)
        view.setupNavigationTitle(search.title)
        self.view = view
    }
    
    func setupWeatherService(){
        service.getWeekdayWeather(woeid: search.woeid)
    }
    
    func tryAgainButtonDidTap() {
        clearTableView()
    }
    
    func rowDidTap(_ row: Int) {
        let model = dataSource[row]
        router.navigateToDatailsScene(weatherData: model)
    }
    
    private func clearTableView() {
        dataSource.removeAll()
        view?.reloadData()
        
    }
    func pullToRefreshDidHappen() {
        service.getWeekdayWeather(woeid: search.woeid)
    }
}

// MARK: Service Output

extension WeekdayPresenter: WeekdayDataServiceDelegate {
    
    func didUpdateWeather(_ weatherData: [WeatherDataModel]) {
        dataSource = weatherData
        view?.hideLoading()
        view?.pullEndFreshing()
        view?.reloadData()
    }
    
    func didFail(error: Error) {
        view?.hideLoading()
    }  
}
