//
//  WeekdayCellsPresenter.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 15/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import Foundation

protocol WeekdayCellPresenterDelegate {
    func setupCell(imageIcon: String, temperature: String, date: String)
}

final class WeekdayCellPresenter {
    private let weatherData: WeatherDataModel
    
    init(model: WeatherDataModel) {
        self.weatherData = model
    }
    
    func attachView(_ view: WeekdayCellPresenterDelegate) {
        let imageIcon = weatherData.weatherStateAbbr
        let temperature = (String(format: "%.1fºC ", weatherData.theTemp))
        let date = weatherData.applicableDate.string(format: .short)
        
        view.setupCell(
            imageIcon: imageIcon,
            temperature: temperature,
            date: date)
    }
}
