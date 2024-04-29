import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    private var continuousUpdates: Bool = false
    private var locationUpdateHandler: ((CLLocation) -> Void)?
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation(withHandler handler: @escaping (CLLocation) -> Void) {
        continuousUpdates = true
        locationUpdateHandler = handler
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        continuousUpdates = false
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if continuousUpdates {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle updated locations
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error.localizedDescription)")
    }
}
