//
//  DirectionsVC.swift
//  Lens App
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit
import MapKit

class DirectionsVC: BaseVC {

    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var directionButtonOuterView: UIView!
    
    //MARK: Variables
    var destinationLocation = CLLocationCoordinate2D()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMarker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentLocation(success: {_ in })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.customiseUI()
    }
    
    func addMarker(){
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(destinationLocation.latitude, destinationLocation.longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        self.mapView.addAnnotation(objectAnnotation)
        
        let location = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        self.centerMapOnLocation(location: location, mapView: self.mapView)
        
    }
    
    func centerMapOnLocation(location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: Private Methods
    private func customiseUI() {
        directionsButton.set(radius: 5.0)
        directionButtonOuterView.set(radius: 5.0)
    }

    //MARK: IBActions
    
    @IBAction func directionButtonAction(_ sender: Any) {
    if !LocationManager.shared.isLoocationAccessEnabled() {
            self.showAlert(message: kLocationMessage, {
                self.openSettings()
            })
            return
        }
        let source = MKMapItem(placemark: MKPlacemark(coordinate: self.currentLocation))
        source.name = "Source"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)))
        destination.name = "Destination"
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonAction()
    }
}
