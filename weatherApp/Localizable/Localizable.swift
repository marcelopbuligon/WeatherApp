//
//  Localizable.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 09/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

enum Localizable {

    enum WelcomePage: String, LocalizableDelegate {
        case title = "welcomeTitle"
        case searchBar = "placeholder"
        case test = "inAppButtonError"
    }
    enum InAppError: String, LocalizableDelegate {
        case title = "inAppTitleError"
        case button = "inAppButtonError"
        case generic = "inAppGenericError"
        case noInternet = "inAppNoInternet"
        case noLocationFound = "inAppNoLocation"
    }
}

