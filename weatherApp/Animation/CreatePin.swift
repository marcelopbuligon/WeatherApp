//
//  CreatePin.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 11/06/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import MapKit

final class CreatePin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
