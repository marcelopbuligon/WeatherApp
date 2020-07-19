//
//  WeatherWeekdayService.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 12/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

protocol WeekdayDataServiceProtocol {
    var delegate: WeekdayDataServiceDelegate? { get set }
    func getWeekdayWeather(woeid: Int)
}

final class WeekdayDataService: WeekdayDataServiceProtocol {
    weak var delegate: WeekdayDataServiceDelegate?
    private let apiRequester: APIRequestProtocol
    
    init(apiRequester: APIRequestProtocol = APIRequest()) {
        self.apiRequester = apiRequester
    }
    
    func getWeekdayWeather(woeid: Int) {
        
        let urlString = "\(urlBase.metaWeather.rawValue)\(woeid)/"
        
        apiRequester.request(
            urlString: urlString,
            method: .get,
            parameters: nil,
            success: { [weak self] (response: WeatherSearchCityModel) in
                let weather = response.consolidatedWeather
                self?.delegate?.didUpdateWeather(weather ?? [])
        }) { [weak self] (error) in
            self?.delegate?.didFail(error: error)
        }
    }
}
