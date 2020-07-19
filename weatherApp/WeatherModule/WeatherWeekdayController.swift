//
//  WeatherWeekdayController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 20/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class WeatherWeekdayController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    private let weatherService = WeekdayDataService()
    private let spinner = SpinnerController()
    private let pullControl = UIRefreshControl()
    
    private var dataSource: [WeatherModel] = []
    private var location: String
    private var city: String
    private var cityCode: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView?.register(WeatherWeekdayCells.nib,forCellReuseIdentifier: WeatherWeekdayCells.identifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        setupWeatherServicee()
        pullToRefresh()
    }
    
    init(search: WeatherSearch) {
        cityCode = search.woeid
        location = search.lattLong
        city = search.title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWeatherServicee(){
        weatherService.delegateData = self
        weatherService.delegateLoadable = self
        weatherService.getWeather(woeid: cityCode)
    }
    
    private func setupNavigationBar() {
        title = city
        navigationController?.navigationBar.prefersLargeTitles = true
        setBackButton(title: city)
    }
    
    private func pullToRefresh() {
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = pullControl
        } else {
            tableView?.addSubview(pullControl)
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        weatherService.getWeather(woeid: cityCode)
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
        pullControl.endRefreshing()
    }
    
    private func showAlert(with message: String) {
        let dialogMessage = UIAlertController(title: Localizable.InAppError.title.localized, message: message, preferredStyle: .alert)
        let tryAgainButton = UIAlertAction(title: Localizable.InAppError.button.localized, style: .default, handler: { [weak self](action) -> Void in
            self?.weatherService.getWeather(woeid: self?.cityCode ?? 0)
        })
        dialogMessage.addAction(tryAgainButton)
        DispatchQueue.main.async { [weak self] in
            self?.present(dialogMessage, animated: true, completion: nil)
        }
    }
}

extension WeatherWeekdayController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: WeatherWeekdayCells.identifier, for: indexPath) as? WeatherWeekdayCells else { return UITableViewCell() }
        let dayOfWeek = dataSource[indexPath.row]
        cell.configure(dayOfWeek)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeader = UIView()
        customHeader.backgroundColor = UIColor.systemBackground
        return customHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = WeatherDetailsViewController(consolidateWeather: dataSource[indexPath.row], coordinates: location, nameCity: city)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension WeatherWeekdayController: WeatherDataOutput, Loadable {
    
    func didUpdateWeather(_ weatherData: [WeatherModel]) {
        dataSource = weatherData
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
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
    
    func didFail(error: Error) {
        showAlert(with: error.localizedDescription)
    }
}
