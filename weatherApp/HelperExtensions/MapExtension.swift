//
//  MapExtension.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 09/06/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
