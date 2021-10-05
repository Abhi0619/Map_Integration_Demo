//
//  ViewController.swift
//  MapIntegrationDemo
//
//  Created by IPS MAC OS 2 on 28/09/21.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManeger = CLLocationManager()
    
    

    @IBOutlet weak var mapKIt: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManeger.requestAlwaysAuthorization()
        locationManeger.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManeger.delegate = self
            locationManeger.desiredAccuracy = kCLLocationAccuracyBest
            locationManeger.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapKIt.addAnnotations([london,oslo,paris,rome,washington])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(chooseMapType))
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            let annotation = MKPointAnnotation()
               // Set the annotation by the lat and long variables
        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
               annotation.title = "User location"
               self.mapKIt.addAnnotation(annotation)
        }
    @objc func chooseMapType(){
        let alert = UIAlertController(title: "Map Type", message: "Choose your prefered map type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
            self?.mapKIt.mapType = .satellite
        }))
        alert.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapKIt.mapType = .standard
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else{return nil}
        
        let identifier = "Capital"
        var anotationView = mapKIt.dequeueReusableAnnotationView(withIdentifier: identifier)
       
        
        if anotationView == nil{
            anotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            anotationView?.rightCalloutAccessoryView = btn
            anotationView?.tintColor = .red
//            anotationView?.image = UIImage(named: "mapPinIcon")
//            let tarnsform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            anotationView?.transform = tarnsform
        }else{
            anotationView?.annotation = annotation
        }
        return anotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else{return}
        let placename = capital.title
        let placeinfo = capital.info
        let alert = UIAlertController(title: placename, message: placeinfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

