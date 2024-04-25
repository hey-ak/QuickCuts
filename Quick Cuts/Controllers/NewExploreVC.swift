//
//  NewExploreVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 25/04/24.
//

import UIKit
import MapKit

class NewExploreVC: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let center = CLLocationCoordinate2D(latitude: 30.483997, longitude: 76.593948)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()  // <-- new instance here
        annotation.coordinate = center
        annotation.title = "Point \(center)"
        mapView.addAnnotation(annotation)
        
        mapView.delegate = self
        
        showRouteOnMap(pickupCoordinate: center, destinationCoordinate: .init(latitude: 19.0330, longitude: 73.0297))
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.9)
            renderer.lineWidth = 7
            return renderer
        }

        return MKOverlayRenderer()
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

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
