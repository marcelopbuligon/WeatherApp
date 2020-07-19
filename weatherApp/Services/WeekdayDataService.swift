//
//  WeatherWeekdayService.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 12/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

final class WeekdayDataService {
    weak var delegateData: WeatherDataOutput?
    weak var delegateLoadable: Loadable?
    private let apiRequester: APIRequestProtocol

    init(apiRequester: APIRequestProtocol = APIRequest()) {
        self.apiRequester = apiRequester
    }
    
    func getWeather(woeid: Int) {
        
        let urlString = "\(urlBase.metaWeather.rawValue)\(woeid)/"
        
        delegateLoadable?.showLoading()
        apiRequester.request(
            urlString: urlString,
            method: .get,
            parameters: nil,
            success: { [weak self] (response: WeatherSearch) in
                let weather = response.consolidatedWeather
                self?.delegateData?.didUpdateWeather(weather ?? [])
                self?.delegateLoadable?.hideLoading()
                
        }) { [delegateLoadable] (error) in
            delegateLoadable?.didFail(error: error)
            delegateLoadable?.hideLoading()
        }
    }
}

enum urlBase: String {
    case metaWeather = "https://www.metaweather.com/api/location/"
}
