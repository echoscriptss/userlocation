//
//  Userlocation.swift
//  Devicemovement
//
//  Created by Yogesh on 9/10/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreLocation

class Userlocation: NSObject,CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    var currentLocation2d:CLLocationCoordinate2D?
    var Currentlatitude = Double()
    var Currentlongitude = Double()
    var stringCurrentCity:String = String()
    var stringCurrentState:String = String()
    var location:String = String()
    var currentAddress:String = String()
    var state:String = String()
    var zip:String = String()
    
    class var sharedInstance: Userlocation
    {
        struct Singleton
        {
            static let instance =  Userlocation()
        }
        return Singleton.instance
    }
    
    func initLocationManager ()
    {
        
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch status
        {
        case .denied:
            print("notdetermined")
            
        case .restricted:
            print("restricted")
            
        default:
            print("nothing")
        }
        
        self.locationManager.delegate = self
        
        self.locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        self.Currentlatitude = lat
        self.Currentlongitude = long
        
        reverseGeocode(self.Currentlatitude, long: self.Currentlongitude)
    }
    
    func stopUpdating()
    {
        locationManager.stopUpdatingLocation()
    }
    
    func reverseGeocode(_ lat:CLLocationDegrees, long: CLLocationDegrees)
    {
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!) //changed!!!
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil
            {
                //print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm                  = placemarks![0]
                print(pm)
                let array               = pm.addressDictionary!["FormattedAddressLines"]
                self.stringCurrentCity  = pm.locality!
                //print(self.stringCurrentCity)
                self.stringCurrentState = pm.administrativeArea!
                //print(self.stringCurrentState)
                self.location           = ((array as! NSArray).object(at: 1)) as! String
                self.currentAddress = ((array as! NSArray).object(at: 0)) as! String
                self.zip = pm.postalCode!
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
}

