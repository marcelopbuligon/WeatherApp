//
//  WeatherService.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 25/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

final class SearchCityNameService {
    weak var delegateSearch: WeatherSearchOutput?
    weak var delegateLoadable: Loadable?
    private let apiRequester: APIRequestProtocol
    private let baseUrl = "https://www.metaweather.com/api/location/"
    
    ///pode receber qualquer classe que implemente o protocolo APIRequestProtocol
    init(apiRequester: APIRequestProtocol = APIRequest()) {
        self.apiRequester = apiRequester
    }
    
    func citySearch(search: String) {
        
        let urlString = "\(urlBase.metaWeather.rawValue)\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        delegateLoadable?.showLoading()
        apiRequester.request(
            urlString: urlString,
            method: .get,
            parameters: nil,
            success: { [weak self] (response: [WeatherSearch]) in
                self?.delegateSearch?.didFindCities(response)
                self?.delegateLoadable?.hideLoading()
        }) { [delegateLoadable] (error) in
            delegateLoadable?.didFail(error: error)
            delegateLoadable?.hideLoading()
        }
    }
}
