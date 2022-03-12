//
//  ViewController.swift
//  TrackerDevice
//
//  Created by Vanina Fileva on 8.03.22.
//

import UIKit
import MapKit
import CoreLocation

class DevicesViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager = CLLocationManager()
    
    var devices: [Device]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let devices = self?.devices else {
                    return
                }
                self?.show(devices)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDevices()
        mapView.delegate = self
    }
    
    @IBAction func showUserLocation(_ sender: Any) {
        showUserLocation()
    }
    
    @IBAction func showDevices(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        guard let devices = devices else {
            return
        }
        show(devices)
    }
}

extension DevicesViewController: MKMapViewDelegate {
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    private func getDevices() {
        DataManager.shared.getDevices { [weak self] devices in
            self?.devices = devices
        }
    }
    
    private func show(_ devices: [Device]) {
        var minLat: CLLocationDegrees?
        var maxLat: CLLocationDegrees?
        var minLng: CLLocationDegrees?
        var maxLng: CLLocationDegrees?
        for device in devices {
            addPin(for: device)
            if minLat == nil || minLat! > device.coordinate.latitude {
                minLat = device.coordinate.latitude
            }
            if maxLat == nil || maxLat! < device.coordinate.latitude {
                maxLat = device.coordinate.latitude
            }
            if minLng == nil || minLng! > device.coordinate.longitude {
                minLng = device.coordinate.longitude
            }
            if maxLng == nil || maxLng! < device.coordinate.longitude {
                maxLng = device.coordinate.longitude
            }
        }
        
        guard let minLat = minLat, let maxLat = maxLat,
              let minLng = minLng, let maxLng = maxLng else {
                  return
              }
        zoomTo(minLat: minLat, maxLat: maxLat, minLng: minLng, maxLng: maxLng)
    }
    
    private func addPin(for device: Device) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = device.coordinate
        annotation.title = "\(device.barrierId ?? "NA") \(device.fCntUp.description)"
        annotation.subtitle = "\(device.battery)%"
        mapView.addAnnotation(annotation)
    }
    
    private func zoomTo(minLat: CLLocationDegrees,
                        maxLat: CLLocationDegrees,
                        minLng: CLLocationDegrees,
                        maxLng: CLLocationDegrees) {
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.15,
                                    longitudeDelta: (maxLng - minLng) * 1.15)
        let coordinate = CLLocationCoordinate2D(latitude: (maxLat + minLat) / 2,
                                              longitude: (maxLng + minLng) / 2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension DevicesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didupdateLocations locations: [CLLocation]) {
        centerOnLocationCoordinate(of: manager)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingUserLocation()
        default:
            break
        }
    }
    
    private func showUserLocation() {
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            startUpdatingUserLocation()
        }
    }
    
    func startUpdatingUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        centerOnLocationCoordinate(of: locationManager)
    }
    
    private func center(on coordinate: CLLocationCoordinate2D) {
        var region = mapView.region
        region.center = coordinate
        mapView.setRegion(region, animated: true)
    }
    
    private func centerOnLocationCoordinate(of manager: CLLocationManager) {
        if let coordinate = manager.location?.coordinate {
            center(on: coordinate)
        }
    }
}




