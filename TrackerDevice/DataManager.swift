//
//  DataManager.swift
//  TrackerDevice
//
//  Created by Vanina Fileva on 8.03.22.
//

import Foundation
import CoreLocation

typealias GetDevicesClosure = (_ devices: [Device]) -> ()

class DataManager {
    
    private init() {
        
    }
    
    static let shared = DataManager()
    
    func getDevices(completion: @escaping GetDevicesClosure) {
        guard let endpoint = URL(string: "https://up2-ui-task-api.azurewebsites.net/api/devices") else {
            return
        }
        
        var request = URLRequest(url: endpoint)
        
        request.setValue("oSzWu8EHuD71bnYxBSevv6iU6PO8UCb37kUcJrUy", forHTTPHeaderField: "x-functions-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization
                    .jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
                return
            }
            let devices = json.compactMap { dictionary in
                Device(dictionary: dictionary)
            }
            completion(devices)
        }
        task.resume()
    }
}

