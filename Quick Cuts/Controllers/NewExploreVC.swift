import UIKit
import MapKit

class NewExploreVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    private var pinImage: UIImage?
    private var isDetailedViewOpen: Bool = false

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailViewTopConstarint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.getCurrentLocation()
        LocationManager.shared.locationUpdateHandler = { location in
            print(location.coordinate)
        }
        
//        let location = CLLocationCoordinate2D(latitude: 35.3398, longitude: 76.3869)
//        let currentLocation = CLLocationCoordinate2D(latitude: 45.3398, longitude: 76.3869)
//        DispatchQueue.main.async {
//            self.showRouteOnMap(pickupCoordinate: currentLocation, destinationCoordinate: location)
//        }
        
        
        pinImage = resizeImage(image: UIImage(named: "location")!, newSize: CGSize(width: 30, height: 30))
        
        let location = CLLocationCoordinate2D(latitude: 30.3398, longitude: 76.3869)
        let region = MKCoordinateRegion( center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        // Create a coordinate for the annotation
            let coordinate = CLLocationCoordinate2D(latitude: 30.348620, longitude: 76.415490)
             
         // Create a custom annotation object
            let annotation = CustomAnnotation(coordinate: coordinate, title: "Ramesh Salon", subtitle: "Macbook", imageName: "location")
             
        // Add the annotation to the map view
            mapView.addAnnotation(annotation)
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        annotationView.image = pinImage
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation { }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        openSalonDetails()
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func openSalonDetails() {
        
        if isDetailedViewOpen == true {
            UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut], animations: {
                self.detailViewTopConstarint.constant = 50
            }, completion: { (finished) in
                self.isDetailedViewOpen = false
            })
        }
        else {
            UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut], animations: {
                self.detailViewTopConstarint.constant = -300
            }, completion: { (finished) in
                self.isDetailedViewOpen = true
            })
        }
        
        
    }
    
    
func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
    request.requestsAlternateRoutes = true
    request.transportType = .any

    let directions = MKDirections(request: request)

    directions.calculate { [unowned self] response, error in
        guard let unwrappedResponse = response else { return }
        
        //for getting just one route
        if let route = unwrappedResponse.routes.first {
            //show on map
            self.mapView.addOverlay(route.polyline)
            //set the map area to show the route
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
        }

    }
}

}


class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, imageName: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: (annotation as! CustomAnnotation).imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


