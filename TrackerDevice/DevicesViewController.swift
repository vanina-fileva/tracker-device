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
            DispatchQueue.main.async { [weak self] in
                guard let devices = self?.devices else {
                    return
                }
                for device in devices {
                    self?.addPin(for: device)
                }
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
    
    private func addPin(for device: Device) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = device.coordinate
        annotation.title = "\(device.barrierId ?? "NA") \(device.fCntUp.description)"
        annotation.subtitle = "\(device.battery)%"
        mapView.addAnnotation(annotation)
    }
}


