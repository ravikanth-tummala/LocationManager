import CoreLocation
import UserNotifications
let interval = 5
protocol LocationProviderDelegate: AnyObject {
    func onLocationChange(_ location: CLLocation)
}

class LocationProvider: NSObject {
    private var locationManager: CLLocationManager
    private var timeoutTimer: Timer? = nil
    var lastLocationDate : NSDate?
    weak var delegate: LocationProviderDelegate?
    
    public static let sharedInstance = LocationProvider()
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
    }
    
    
    
    func requestLocationUpdates() -> Void {
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        }
        locationManager.startUpdatingLocation()
        timeoutTimer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(self.stopAndRequestAgain),userInfo: nil, repeats: true)
    }
    
    @objc func stopAndRequestAgain(){
        locationManager.startUpdatingLocation()
    }
    
    func removeLocationUpdates() -> Void {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
    
    func updateLocation(_ loc:CLLocation){
        lastLocationDate = NSDate()
    
        showNotification(loc,"LocationManager","notification.id.01".random())
    }
    
    func isItTime(now:NSDate) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate! as Date)
        return Int(timePast) > interval
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization \(status.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = locations.last else { return }
        if lastLocationDate == nil {
            updateLocation(location)
        } else if(isItTime(now: NSDate())){
            updateLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
}
extension String {
     func random() -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<5 {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
