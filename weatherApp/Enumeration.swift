//
//  Enumeration.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 13/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

enum urlBase: String {
    case metaWeather = "https://www.metaweather.com/api/location/"
    case searchQuery = "search/?query="
    case searchLatLog = "search/?lattlong="
}

enum localizable {
    
    enum welcomePage: String, LocalizableDelegate {
        case title = "welcomeTitle"
        case searchBar = "placeholder"
        case test = "inAppButtonError"
    }
    enum inAppError: String, LocalizableDelegate {
        case title = "inAppTitleError"
        case button = "inAppButtonError"
        case generic = "inAppGenericError"
        case noInternet = "inAppNoInternet"
        case noLocationFound = "inAppNoLocation"
    }
}

enum  latLong: Double {
    case brazilLat = -14.242920
    case brazilLong = -54.387829
}
