import UIKit
import MapKit
import DropDown

class NewExploreVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    private var pinImage: UIImage?
    private var currentSalonData:SalonModel?
    private var showAllButton: UIBarButtonItem?
    private let dropDown = DropDown()
    private var isCardSelected:Bool = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var animatingView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailViewTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var salonDetailedInfoCardImage: UIImageView!
    @IBOutlet weak var salonDetailedInfoCardName: UILabel!
    @IBOutlet weak var salonDetailedInfoCardAddress: UILabel!
    @IBOutlet weak var salonDetailedInfoCardTotalReview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        centerToMyLocation()
        setUpDropDown()
        Task {
            populateSalonData()
        }
    }
    
    
    private func filterSalonDataAccToRadius() {
        let fullData = allSalonData
        var filteredSalons = [SalonModel]()
        let location = LocationManager.shared.currentLocation
        
        for item in fullData {
            if let lat = item.latitude,
               let long = item.longitude,
               let coordinate = location {
                let salonCoordinate = CLLocation(latitude: lat,
                                                 longitude: long)
                
                let distanceInMeters = salonCoordinate.distance(from: coordinate) / 1000
                print("dfdfsdfds",distanceInMeters,item.salonName)
                
                if distanceInMeters < 5 {
                    filteredSalons.append(item)
                }
            }
            else {
                filteredSalons.append(item)
            }
        }
        
        allSalonData = filteredSalons
    }

    @IBAction func makePolilineDidTape(_ sender: Any) {
        guard let salonData = currentSalonData else { return }
        guard let lat = salonData.latitude,
              let long = salonData.longitude else { return }
        let salonCoordinate = CLLocationCoordinate2D(latitude: lat,
                                                     longitude: long)
        
        let location = LocationManager.shared.currentLocation
        if let coordinate = location?.coordinate {
            DispatchQueue.main.async {
                self.showRouteOnMap(pickupCoordinate: coordinate,
                                    destinationCoordinate: salonCoordinate)
                self.addShowAllButton()
                self.isCardSelected = false
                self.closeCardView()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard allSalonData.count > 0 else { return }
        if searchText.isEmpty == true {
            self.currentSalonData = nil
            self.reinitilizeAllAnotations()
            return
        }
        let filteredData = allSalonData.filter ({ $0.salonName.contains(searchText) })
        if filteredData.count > 0 {
            let salonName = filteredData.compactMap { $0.salonName }
            print(salonName)
            dropDown.dataSource = salonName
            dropDown.show()
        } else {
            dropDown.dataSource = []
            dropDown.hide()
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
                let selectedSalon = allSalonData.first(where: { $0.salonName == item })
                if let selectedSalon = selectedSalon {
                    self.currentSalonData = selectedSalon
                    self.clearAllAnotations()
                    self.populateAnotation(selectedSalon)
                    self.populateCardData(selectedSalon)
                    self.centerToGivenCoordinate(selectedSalon)
                    self.openCardView()
                }
                else {
                    self.currentSalonData = nil
                    self.reinitilizeAllAnotations()
                }
            }
        }
    }
    
    private func centerToGivenCoordinate(_ salonData:SalonModel) {
        guard let lat = salonData.latitude,
              let long = salonData.longitude else { return }
        
        let center = CLLocationCoordinate2D(latitude: lat,
                                                longitude: long)
        
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func setUpDropDown() {
        dropDown.anchorView = searchBar
        dropDown.dataSource = []
        dropDown.bottomOffset = CGPoint(x: 20,
                                        y: searchBar.bounds.height)
        dropDown.width = searchBar.bounds.width - 58
    }
    
    private func removeShowAllButton() {
        showAllButton = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    private func addShowAllButton() {
        showAllButton = UIBarButtonItem(title: "All Salons",
                                        style: .plain,
                                        target: self,
                                        action: #selector(showAllAction))
        
        navigationItem.rightBarButtonItem = showAllButton
    }
    
    @objc
    func showAllAction() {
        mapView.removeOverlays(mapView.overlays)
        currentSalonData = nil
        reinitilizeAllAnotations()
        centerToMyLocation()
        removeShowAllButton()
    }
    
    private func initialSetup() {
        mapView.delegate = self
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.getCurrentLocation()
        LocationManager.shared.locationUpdateHandler = { [weak self] location in }
        let locationImage = UIImage(named: "location")!
        pinImage = resizeImage(image:locationImage,
                               newSize: CGSize(width: 30,
                                               height: 30))
        if let _ =  LocationManager.shared.currentLocation {
            DispatchQueue.main.async {
                self.filterSalonDataAccToRadius()
                self.currentSalonData = nil
                self.reinitilizeAllAnotations()
            }
        }
    }
    
    private func populateSalonData() {
        let _ = allSalonData.map { salon in
            populateAnotation(salon)
        }
    }
    
    private func centerToMyLocation() {
        let location = LocationManager.shared.currentLocation
        if let coordinate = location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                longitude: coordinate.longitude)
            let region = MKCoordinateRegion(center: center,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                   longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func populateAnotation(_ salonData:SalonModel) {
        guard let lat = salonData.latitude,
              let long = salonData.longitude else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat,
                                                longitude: long)
        
        let annotation = CustomAnnotation(coordinate: coordinate,
                                          title: salonData.salonName,
                                          subtitle: salonData.subTitle,
                                          imageName: salonData.image,
                                          salonData: salonData)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: "CustomAnnotationView")
        annotationView.canShowCallout = true
        annotationView.image = pinImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let _ = view.annotation { }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.reuseIdentifier == "CustomAnnotationView",
              let annotation = view.annotation as? CustomAnnotation,
              let salonData = annotation.salonData else {
            currentSalonData = nil
            reinitilizeAllAnotations()
            isCardSelected = false
            return }
        
        currentSalonData = salonData
        clearAllAnotations()
        populateAnotation(salonData)
        populateCardData(salonData)
        
        if isCardSelected == false {
            isCardSelected = true
            openCardView()
        }
        else {
            isCardSelected = false
            currentSalonData = nil
            reinitilizeAllAnotations()
            closeCardView()
        }
    }
    
    private func populateCardData(_ salonData:SalonModel) {
        salonDetailedInfoCardImage.image = UIImage(named: salonData.image ?? "location")
        salonDetailedInfoCardName.text = salonData.salonName
        salonDetailedInfoCardAddress.text = salonData.address
    }
    
    private func clearAllAnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    private func reinitilizeAllAnotations() {
        clearAllAnotations()
        populateSalonData()
        closeCardView()
    }
    
    private func openCardView() {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.detailViewTopConstarint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in })
    }
    
    private func closeCardView() {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.detailViewTopConstarint.constant = -300
            self.view.layoutIfNeeded()
        }, completion: {_  in })
    }
    
    private func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            if let route = unwrappedResponse.routes.first {
                DispatchQueue.main.async {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                                   edgePadding: UIEdgeInsets.init(top: 10.0,
                                                                                  left: 20.0,
                                                                                  bottom: 100.0,
                                                                                  right: 20.0),
                                                   animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
    
    private func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String?
    var salonData:SalonModel?
    
    init(coordinate: CLLocationCoordinate2D,
         title: String?,
         subtitle: String?,
         imageName: String?,
         salonData:SalonModel?) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.salonData = salonData
    }
}
