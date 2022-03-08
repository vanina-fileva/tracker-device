//
//  ViewController.swift
//  TrackerDevice
//
//  Created by Vanina Fileva on 8.03.22.
//

import UIKit
import MapKit

class DevicesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var devices: [Device]? {
        didSet {
            DispatchQueue.main.async {
                //todo: show on map
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getDevices()
    }
    
    private func getDevices() {
        DataManager.shared.getDevices { [weak self] devices in
            self?.devices = devices
        }
    }
}

