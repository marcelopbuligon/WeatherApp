//
//  WeatherSearchViewController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 16/06/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    private var dataSource: [WeatherSearch] = []
    private let weatherService = SearchCityNameService()
    private let spinner = SpinnerController()
    private let locationManager  = CLLocationManager()
    private let cellIdentifier = "CityCell"
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupServiceDelegate()
        setupLocationManager()
        setupTableView()
        setupSearchBar()
        setupNavigationBar()
        navigationBarTitleAnimation()
    }
    
    private func setupServiceDelegate(){
        weatherService.delegateSearch = self
        weatherService.delegateLoadable = self
    }
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func cleanTableView(){
        dataSource.removeAll()
        tableView?.reloadData()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizable.WelcomePage.searchBar.localized
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setBackButton(title: Localizable.WelcomePage.title.localized)
    }
    
    private func navigationBarTitleAnimation() {
        title = ""
        var charIndex = 0.0
        let titleText = Localizable.WelcomePage.title.localized
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.title?.append(letter)
            }
            charIndex += 1
        }
    }
    
    private func showAlert(with message: String) {
        let dialogMessage = UIAlertController(
            title: Localizable.InAppError.title.localized,
            message: message,
            preferredStyle: .alert
        )
        let tryAgainButton = UIAlertAction(
            title: Localizable.InAppError.button.localized,
            style: .default,
            handler: { [weak self](action) -> Void in
                self?.searchController.searchBar.text = ""
                self?.cleanTableView()
        })
        dialogMessage.addAction(tryAgainButton)
        DispatchQueue.main.async { [weak self] in
            self?.present(dialogMessage, animated: true, completion: nil)
        }
    }
}

extension WeatherSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputTextByUser = searchController.searchBar.text else { return }
        let characterCount  = inputTextByUser.count
        if characterCount  > 2 {
            let inputText = "search/?query=\(inputTextByUser)"
            weatherService.citySearch(search: inputText)
        } else {
            cleanTableView()
        }
    }
}

extension WeatherSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let city = dataSource[indexPath.row]
        cell.textLabel?.text = city.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherController = WeatherWeekdayController(search: dataSource[indexPath.row])
        navigationController?.pushViewController(weatherController, animated: true)
    }
}

extension WeatherSearchViewController: WeatherSearchOutput, Loadable {
    
    func showLoading() {
        spinner.show(addSpinner: spinner)
        addChild(spinner)
        view.addSubview(spinner.view)
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.hide()
        }
    }
    
    func didFindCities(_ citiesArray: [WeatherSearch]) {
        dataSource = citiesArray
        DispatchQueue.main.sync { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    func didFail(error: Error) {
        showAlert(with: error.localizedDescription)
    }    
}

extension WeatherSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let lattlong = "search/?lattlong=\(lat),\(lon)"
            weatherService.citySearch(search: lattlong)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(with: Localizable.InAppError.noLocationFound.localized)
    }
}
