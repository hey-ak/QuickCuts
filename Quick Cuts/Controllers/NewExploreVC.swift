import UIKit
import MapKit

class NewExploreVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: 30.3398, longitude: 76.3869)
        let region = MKCoordinateRegion( center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        // Create a coordinate for the annotation
            let coordinate = CLLocationCoordinate2D(latitude: 30.348620, longitude: 76.415490)
             
         // Create a custom annotation object
            let annotation = CustomAnnotation(coordinate: coordinate, title: "Amit Kumar", subtitle: "Macbook", imageName: "location")
             
        // Add the annotation to the map view
            mapView.addAnnotation(annotation)
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation { }
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
