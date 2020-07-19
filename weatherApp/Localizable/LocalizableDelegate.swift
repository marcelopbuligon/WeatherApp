//
//  LocalizableDelegate.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 09/07/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import Foundation

protocol LocalizableDelegate {
    var rawValue: String { get }
    var table: String? { get }
    var localized: String { get }
}
extension LocalizableDelegate {
    
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }
    
    var table: String? {
        return nil
    }
}
