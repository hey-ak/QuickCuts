//
//  ExploreVCViewController.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

//import UIKit
//import MapKit
//
//class ContentView: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
//
//   
//    @IBOutlet weak var mapView: MKMapView!
//    
//    
//    var results = [MKMapItem]()
//    var mapselection: MKMapItem?
//    var route: MKRoute?
//    var routeDestination: MKMapItem?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        mapView.delegate = self
//        //searchText.delegate = self
//        
//        let center = CLLocationCoordinate2D(latitude: 30.483997, longitude: 76.593948)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
//        mapView.setRegion(region, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = center
//        annotation.title = "My location"
//        mapView.addAnnotation(annotation)
//    }
//    
//    @IBAction func searchButtonTapped(_ sender: UIButton) {
//        guard let query = searchText.text else { return }
//        searchPlaces(query: query)
//    }
//    
//    @IBAction func getDirectionButtonTapped(_ sender: UIButton) {
//        fetchRoute()
//    }
//
//    func searchPlaces(query: String) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//        request.region = mapView.region
//
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            guard let response = response, error == nil else {
//                return
//            }
//            self.results = response.mapItems
//        }
//    }
//
//    func fetchRoute() {
//        if let mapItem = mapselection {
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 30.483997, longitude: 76.593948)))
//            request.destination = mapItem
//
//            let directions = MKDirections(request: request)
//            directions.calculate { response, error in
//                guard let route = response?.routes.first, error == nil else {
//                    return
//                }
//                
//                self.route = route
//                self.routeDestination = request.destination
//                
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
//            }
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let routePolyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: routePolyline)
//            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.9)
//            renderer.lineWidth = 7
//            return renderer
//        }
//        return MKOverlayRenderer()
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
