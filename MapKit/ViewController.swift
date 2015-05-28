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
        
        let latDist: CLLocationDistance = 1000.0
        let longiDist: CLLocationDistance = 1000.0
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        //let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, longiDist);
        
        mapView.setRegion(region, animated: true)
        
        // Pin
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "8Beat"
        annotation.subtitle = "八王子駅徒歩4分"
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func goTo8Beat(sender: AnyObject) {
        35.713768
        // Direction
        var fromCoordinate: CLLocationCoordinate2D = mapView.userLocation.location.coordinate
        //var fromCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.713768, 139.777254)
        
        var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.657524, 139.337159)
        
        var fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        var toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        
        var fromItem = MKMapItem(placemark:fromPlacemark);
        var toItem = MKMapItem(placemark:toPlacemark);
        
        let request = MKDirectionsRequest()
        request.setSource(fromItem)
        request.setDestination(toItem)
        request.requestsAlternateRoutes = true;
        request.transportType = MKDirectionsTransportType.Walking
        let directions = MKDirections(request:request)
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            if ((error) != nil) {
                var alert = UIAlertController(title: "Info", message: "Route Error", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if (response.routes.isEmpty) {
                var alert = UIAlertController(title: "Info", message: "No Route", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            let route: MKRoute = response.routes[0] as! MKRoute
            self.mapView.addOverlay(route.polyline!)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LocationManager
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var alert = UIAlertController(title: "Info", message: "Location Updated", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        var locations: NSArray = locations as NSArray
        var lastLocation: CLLocation = locations.lastObject as! CLLocation
        var coordinate: CLLocationCoordinate2D = lastLocation.coordinate
        
        let latDist: CLLocationDistance = 100
        let longiDist: CLLocationDistance = 100
        
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, longiDist);
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Error")
    }
    
    // MARK: - MapView
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
}

