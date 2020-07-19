//
//  WeatherDetailsViewController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 29/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import MapKit

final class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var theTempLabel: UILabel?
    @IBOutlet weak var maxTempLabel: UILabel?
    @IBOutlet weak var minTempLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var rainLabel: UILabel?
    @IBOutlet weak var windLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var cityLabel: UILabel?
    
    private let presenter: DetailsPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        loadLocationOnTheMap()
        mapView?.delegate = self
    }
    
    init(presenter: DetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadLocationOnTheMap() {
        mapView?.centerToLocation(presenter.formattedCoordinates())
        presenter.didCenterToLocation()
    }
}

// MARK: - Presenter output

extension DetailsViewController: DetailsPresenterDelegate {
    func setupRain(rain: String) {
        self.rainLabel?.text = rain
    }
    
    func setupWind(wind: String) {
        self.windLabel?.text = wind
    }
    
    func setupHumidity(humidity: String) {
        self.humidityLabel?.text = humidity
    }
    
    func setupIcon(iconImage: String) {
        self.iconImageView?.image = UIImage(named: iconImage) ?? UIImage()
    }
    
    func setupDate(date: String) {
        self.dateLabel?.text = date
    }
    
    func setupCityName(city: String) {
        self.cityLabel?.text = city
    }
    
    func addCityPinToMap(latitude: Double, longitude: Double, city: String) {
        let pinMap = CreatePin(
            title: city,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView?.addAnnotation(pinMap)
    }
    
    func setupTempLabel(actualTemp: String, maxTemp: String, minTemp: String) {
        self.theTempLabel?.text = actualTemp
        self.maxTempLabel?.text = maxTemp
        self.minTempLabel?.text = minTemp
    }
}
