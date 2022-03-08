//
//  Device.swift
//  TrackerDevice
//
//  Created by Vanina Fileva on 8.03.22.
//

import Foundation

class Device {
    
    let barrierId: String?
    let lng: Double
    let lat: Double
    let battery: Int
    let fCntUp: Int

    init?(dictionary: [String: Any]) {
        guard let lastData = dictionary["lastData"] as? [String: Any],
        let content = lastData["content"] as? [String: Any],
        let lng = content["lng"] as? Double,
        let lat = content["lat"] as? Double,
        let battery = content["battery"] as? Int,
        let fCntUp = content["fCntUp"] as? Int else {
            return nil
        }
        
        self.lng = lng
        self.lat = lat
        self.battery = battery
        self.fCntUp = fCntUp
        self.barrierId = (content["meta"] as? [String: Any])?["barrierId"] as? String
    }
}
