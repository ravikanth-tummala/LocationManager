//
//  ViewController.swift
//  LocationExample
//
//  Created by GeoSpark on 20/10/22.
//

import UIKit
import CoreLocation
import Roam

class ViewController: UIViewController{
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startTracking(){
        LocationProvider.sharedInstance.requestLocationUpdates()
    }
    
    @IBAction func stopTrackingProvider(_ sender: Any) {
        LocationProvider.sharedInstance.removeLocationUpdates()
    }
    
    @IBAction func startTrackingProvider(_ sender: Any) {
        startTracking()
    }
    
    @IBAction func stopTrackingRoam(_ sender: Any) {
        Roam.stopTracking()
    }
    
    @IBAction func startTrackingRoam(_ sender: Any) {
        Roam.requestLocation()
        let trackingMethod = RoamTrackingCustomMethods()
        
        trackingMethod.allowBackgroundLocationUpdates = true //self.backLocationSegmentAction.selectedSegmentIndex == 1
        trackingMethod.pausesLocationUpdatesAutomatically = false//self.pauseSegmentAction.selectedSegmentIndex == 1
        trackingMethod.showsBackgroundLocationIndicator = true
        trackingMethod.desiredAccuracy = .kCLLocationAccuracyBestForNavigation//self.getDesiredAccuracy()
        trackingMethod.activityType = .fitness//self.getActivity()
        trackingMethod.useVisits = true
        trackingMethod.useSignificant = true
        trackingMethod.useStandardLocationServices = false
        trackingMethod.useRegionMonitoring  = true
        trackingMethod.updateInterval = 15
        Roam.startTracking(.custom, options: trackingMethod)
    }
    
    @IBAction func subscribeRoam(_ sender: Any) {
        Roam.createUser("Test", nil) {  (user, errorStatus) in
            print("User id \(user?.userId)")
            if errorStatus == nil {
                Roam.publishOnly()
                Roam.toggleListener(Events: true, Locations: true) { user, error in
                    Roam.subscribe(.Both, (user?.userId)!)
                }
            }
        }
    }

}
