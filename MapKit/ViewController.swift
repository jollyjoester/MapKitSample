//
//  ViewController.swift
//  MapKit
//
//  Created by jollyjoester_pro on 1/19/15.
//  Copyright (c) 2015 Hideyuki Nanashima. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Map
        //mapView.delegate = self
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        // Location
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        // Map
        let latitude: CLLocationDegrees = 35.657524
        let longitude: CLLocationDegrees = 139.337159
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude) as CLLocationCoordinate2D
        
//        let latDist: CLLocationDistance = 1000.0
//        let longiDist: CLLocationDistance = 1000.0
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        //let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, longiDist);
        
        mapView.setRegion(region, animated: true)
        
        // Pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "8Beat"
        annotation.subtitle = "八王子駅徒歩4分"
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func goTo8Beat(_ sender: AnyObject) {
        // Direction
        let fromCoordinate: CLLocationCoordinate2D = mapView.userLocation.location!.coordinate
        //var fromCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.713768, 139.777254)
        
        let toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.657524, 139.337159)
        
        let fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        let toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        
        let fromItem = MKMapItem(placemark:fromPlacemark);
        let toItem = MKMapItem(placemark:toPlacemark);
        
        let request = MKDirectionsRequest()
        request.source = fromItem
        request.destination = toItem
        request.requestsAlternateRoutes = true;
        request.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request:request)
        directions.calculate(completionHandler: {
            (response:MKDirectionsResponse?, error: Error?) -> Void in
            if ((error) != nil) {
                let alert = UIAlertController(title: "Info", message: "Route Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if (response?.routes.isEmpty)! {
                let alert = UIAlertController(title: "Info", message: "No Route", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let route: MKRoute = response!.routes[0] 
            self.mapView.add(route.polyline)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let alert = UIAlertController(title: "Info", message: "Location Updated", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        let locations: NSArray = locations as NSArray
        let lastLocation: CLLocation = locations.lastObject as! CLLocation
        let coordinate: CLLocationCoordinate2D = lastLocation.coordinate
        
        let latDist: CLLocationDistance = 100
        let longiDist: CLLocationDistance = 100
        
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, longiDist);
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error")
    }
    
    // MARK: - MapView
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
    }
}

