//
//  WeatherDetailsViewController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 29/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import MapKit

final class WeatherDetailsViewController: UIViewController, MKMapViewDelegate {
    
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
    
    private let weather: WeatherModel
    private let brazilLat = -14.242920
    private let brazilLong = -54.387829
    
    private var location: String
    private var city: String
    
    init(consolidateWeather: WeatherModel, coordinates: String, nameCity: String) {
        weather = consolidateWeather
        location = coordinates
        city = nameCity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTemp()
        setupDetails()
        setupIconAndLabels()
        loadLocationOnTheMap()
        mapView?.delegate = self
    }
    
    private func formattedCoordinates() -> CLLocation {
        let coordinates = location
        let coordinatesArray = coordinates.components(separatedBy: ",")
        
        guard coordinatesArray.count == 2,
            let latitude = Double(coordinatesArray[0]),
            let longitude = Double(coordinatesArray[1])
            else { return .init(latitude: brazilLat, longitude: brazilLong)}
        
        return CLLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    private func loadLocationOnTheMap() {
        mapView?.centerToLocation(formattedCoordinates())
        addPinToMap(
            latitude: formattedCoordinates().coordinate.latitude ,
            longitude: formattedCoordinates().coordinate.longitude
        )
    }
    
    private func addPinToMap(latitude: Double, longitude: Double) {
        let pinMap = CreatePin(
            title: city,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView?.addAnnotation(pinMap)
    }
    
    private func setupTemp() {
        theTempLabel?.text = (String(format: "%.0fºC ", weather.theTemp))
        maxTempLabel?.text = (String(format: "%.0fºC ", weather.maxTemp))
        minTempLabel?.text = (String(format: "%.0fºC ", weather.minTemp))
    }
    
    private func setupDetails() {
        rainLabel?.text = (String("\(weather.predictability)%"))
        windLabel?.text = (String(format: "%.0f km/h ", weather.windSpeed))
        humidityLabel?.text = (String("\(weather.humidity)%"))
    }
    
    private func setupIconAndLabels() {
        iconImageView?.image = UIImage(named: weather.weatherStateAbbr) ?? UIImage()
        dateLabel?.text = weather.applicableDate.string(format: .long)
        cityLabel?.text = city
    }
}
