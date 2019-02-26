//
//  ViewController.swift
//  mmmmm
//
//  Created by Harshit Aggarwal on 2/25/19.
//  Copyright © 2019 Harshit Aggarwal. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find map style json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var Update: UIButton!
    
    var pin = UIImage(named: "Pin")
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let camera = GMSCameraPosition.camera(withLatitude: 39.9502279, longitude: -75.16368, zoom: 12.0)
        self.mapView.mapStyle(withFilename: "data", andType: "json")
        mapView.camera = camera
    }
    
    @IBAction func UpdateMap() {
        
        guard let locate = address.text else { return }
        
        geocoder.geocodeAddressString(locate) {
            [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let placemark = placemarks?.first else {
                print("No placemark")
                return }
            guard let location = placemark.location else {
                print("No location in placemark")
                return }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
            self?.mapView.mapStyle(withFilename: "data", andType: "json")
            self?.mapView.camera = camera
            showMarker(position: location.coordinate)
        }
        
        func showMarker(position: CLLocationCoordinate2D){
            let markerView = UIImageView(image: pin)
            let marker = GMSMarker()
            marker.position = position
            marker.iconView = markerView
            marker.map = mapView
        }
    }
}


