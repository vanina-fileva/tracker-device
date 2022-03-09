//
//  Device.swift
//  TrackerDevice
//
//  Created by Vanina Fileva on 8.03.22.
//

import CoreLocation

class Device {
    
    let barrierId: String?
    let battery: Int
    let fCntUp: Int
    let coordinate: CLLocationCoordinate2D

    init?(dictionary: [String: Any]) {
        guard let lastData = dictionary["lastData"] as? [String: Any],
        let content = lastData["content"] as? [String: Any],
        let lng = content["lng"] as? Double,
        let lat = content["lat"] as? Double,
        (lng != 0 && lat != 0),
        let battery = content["battery"] as? Int,
        let fCntUp = content["fCntUp"] as? Int else {
            return nil
        }
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.battery = battery
        self.fCntUp = fCntUp
        barrierId = (content["meta"] as? [String: Any])?["barrierId"] as? String
    }
}
