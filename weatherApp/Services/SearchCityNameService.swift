//
//  WeatherService.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 25/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

protocol SearchCityNameServiceProtocol {
    var delegate: SearchServiceDelegate? { get set }
    func citySearch(query: String)
}

final class SearchCityNameService: SearchCityNameServiceProtocol {
    weak var delegate: SearchServiceDelegate?
    private let apiRequester: APIRequestProtocol
    
    init(apiRequester: APIRequestProtocol = APIRequest()) {
        self.apiRequester = apiRequester
    }
    
    func citySearch(query: String) {
        
        let urlString = "\(urlBase.metaWeather.rawValue)\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        apiRequester.request(
            urlString: urlString,
            method: .get,
            parameters: nil,
            success: { [weak self] (response: [WeatherSearchCityModel]) in
                self?.delegate?.didFindCities(response)
        }) { [delegate] (error) in
            delegate?.didFail(error: error)
        }
    }
}
