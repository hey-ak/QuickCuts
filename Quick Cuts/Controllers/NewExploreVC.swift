import UIKit
import MapKit

class NewExploreVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupLocationManager()

        mapView.delegate = self
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for places"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor(white: 1, alpha: 0.85)
        searchBar.layer.cornerRadius = 25
        searchBar.clipsToBounds = true
        view.addSubview(searchBar)

        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {

            glassIconView.image = UIImage(systemName: "mic.fill")
            glassIconView.tintColor = .gray
        }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text

        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response else { return }

            self.mapView.removeAnnotations(self.mapView.annotations)

            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
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
        if let annotation = view.annotation {
            fetchPlaceDetails(for: annotation)
        }
    }

    private func fetchPlaceDetails(for annotation: MKAnnotation) {
        let placeDetails = "Details about \(annotation.title ?? "") fetched from the internet."
        showCardView(with: placeDetails)
    }

    private func showCardView(with details: String) {
        let cardViewController = CardViewController()
        cardViewController.placeDetails = details
        cardViewController.modalPresentationStyle = .overFullScreen
        present(cardViewController, animated: true, completion: nil)
    }
}

class CardViewController: UIViewController {

    var placeDetails: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.9, alpha: 1)

        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = placeDetails
        textView.isEditable = false
        textView.backgroundColor = .clear
        view.addSubview(textView)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("􀄩", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeCardView), for: .touchUpInside)
        view.addSubview(closeButton)

        let height = UIScreen.main.bounds.height * 0.5
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            textView.heightAnchor.constraint(equalToConstant: height),
            
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10)
        ])
    }

    @objc private func closeCardView() {
        dismiss(animated: true, completion: nil)
    }
}
