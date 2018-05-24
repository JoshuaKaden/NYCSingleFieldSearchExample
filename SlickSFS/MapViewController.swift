//
//  MapViewController.swift
//  SlickSFS
//
//  Created by Kaden, Joshua on 5/24/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import MapKit

final class MapViewController: UIViewController {
    var location: Location? {
        didSet {
            removePins()
            guard let location = location else { return }
            addPin(location: location)
            centerMap(location: location)
        }
    }
    
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    private func addPin(location: Location) {
        let pin = LocationPin(location: location)
        mapView.addAnnotation(pin)
    }
    
    fileprivate func centerMap(location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate.coreLocationCoordinate, 800, 800)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func removePins() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationPin else { return nil }
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        // Check to see if a reusable annotation view is available before creating a new one.
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // else create a new annotation view
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
        }
        
        view.animatesDrop = true
        
        return view
    }
}
