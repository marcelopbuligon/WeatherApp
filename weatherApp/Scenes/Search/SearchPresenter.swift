//
//  SearchPresenter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 13/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import CoreLocation

protocol SearchPresenterDelegate {
    func showAlert(message: String, buttonTitle: String, title: String)
    func showLoading()
    func hideLoading()
    func reloadData()
    func resetSearchBarText()
}

final class SearchPresenter: NSObject {
    var dataSource: [WeatherSearchCityModel] = []
    private var view: SearchPresenterDelegate?
    private var service: SearchCityNameServiceProtocol
    private let locationManager  = CLLocationManager()
    private var router: SearchRouterProtocol
    
    init(
        service: SearchCityNameServiceProtocol = SearchCityNameService(),
        router: SearchRouterProtocol
    ) {
        self.service = service
        self.router = router
        super.init()
        
        self.service.delegate = self
    }
    
    func attachView(_ view: SearchPresenterDelegate) {
        self.view = view
        setupLocationManager()
    }
    
    func inputTextDidChange(_ text: String) {
        let characterCount  = text.count
        if characterCount  > 2 {
            let inputText = "\(urlBase.searchQuery.rawValue)\(text)"
            service.citySearch(query: inputText)
        } else {
            clearTableView()
        }
    }
    
    func tryAgainButtonDidTap() {
        view?.resetSearchBarText()
        clearTableView()
    }
    
    func rowDidTap(_ row: Int) {
        let model = dataSource[row]
        router.navigateToWeekScene(model: model)
    }
    
    private func clearTableView() {
        dataSource.removeAll()
        view?.reloadData()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: Service Output

extension SearchPresenter: SearchServiceDelegate {
    
    func didFindCities(_ cities: [WeatherSearchCityModel]) {
        dataSource = cities
        
        view?.hideLoading()
        view?.reloadData()
    }
    
    func didFail(error: Error) {
        view?.hideLoading()
        
        view?.showAlert(
            message: localizable.inAppError.generic.localized,
            buttonTitle: localizable.inAppError.button.localized,
            title: localizable.inAppError.title.localized
        )
    }
}

// MARK: CoreLocation Output

extension SearchPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let lattlong = "\(urlBase.searchLatLog.rawValue)\(lat),\(lon)"
            service.citySearch(query: lattlong)
            view?.showLoading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        view?.showAlert(
            message: localizable.inAppError.generic.localized,
            buttonTitle: localizable.inAppError.button.localized,
            title: localizable.inAppError.title.localized
        )
    }
}
