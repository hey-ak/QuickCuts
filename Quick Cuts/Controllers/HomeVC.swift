import UIKit
import CoreLocation
import SDWebImage
import FirebaseFirestoreInternal
import FirebaseCore

enum SeeAllState {
    case selected
    case unselected
}

class HomeVC: UIViewController {
    
    
    private var contentSizeObservation:NSKeyValueObservation?
    private var topRatedSalons = [SalonModel]()
    
    private var ratedCollectionViewData:Int? {
        didSet {
            ratedCollectionView.reloadData()
        }
    }
    
    
    private var mainCollectionViewData:Int? {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    private var ratedCollectionSeeAllState:SeeAllState = .unselected {
        didSet {
            switch ratedCollectionSeeAllState {
            case .selected:
                self.ratedCollectionViewData = topRatedSalons.count
                
            case .unselected:
                self.ratedCollectionViewData = nil
            }
        }
    }
    
    private var mainCollectionSeeAllState:SeeAllState = .unselected {
        didSet {
            switch mainCollectionSeeAllState {
            case .selected:
                self.mainCollectionViewData = allSalonData.count
                
            case .unselected:
                self.mainCollectionViewData = nil
            }
        }
    }
    
    
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!{
        didSet{
            mainCollectionView.registerCellFromNib(cellID: "HomeCollectionCell")
        }
    }
    @IBOutlet weak var catagoryCollectionView: UICollectionView!{
        didSet{
            catagoryCollectionView.registerCellFromNib(cellID: "HomeCatagoryCollectionCell")
        }
    }
    @IBOutlet weak var ratedCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratedCollectionView: UICollectionView!{
        didSet{
            ratedCollectionView.registerCellFromNib(cellID: "HomeCollectionCell")
            contentSizeObservation = ratedCollectionView.observe(\.contentSize, options: [.new]) { [weak self] ratedCollectionView, change in
                self?.ratedCollectionView.invalidateIntrinsicContentSize()
                self?.ratedCollectionHeightConstraint.constant = ratedCollectionView.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private let HomeServicesArray: [HomeServices] = [
        HomeServices(serviceImage: "serviceImage1", serviceName: "HairCut"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Pedicure"),
        HomeServices(serviceImage: "serviceImage2", serviceName: "Massage"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Facial"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Hair Coloring"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Shaving"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratedCollectionSeeAllState = .unselected
        mainCollectionSeeAllState = .unselected
        catagoryCollectionView.reloadData()
        LocationManager.shared.locationUpdateHandler = { [weak self] location in
            self?.getCityStateFromCoordinates(location, completion: {[weak self]  locationString in
                DispatchQueue.main.async {
                    self?.locationLable.text = locationString
                }
            })
        }
        LocationManager.shared.getCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleSaloneData()
    }
    
    @IBAction func ratedCollectionSeeAllDidTapped(_ sender: Any) {
        ratedCollectionSeeAllState = (ratedCollectionSeeAllState == .selected) ? .unselected : .selected
    }
    
    @IBAction func mainCollectionSeeAllDidTapped(_ sender: Any) {
        mainCollectionSeeAllState = (mainCollectionSeeAllState == .selected) ? .unselected : .selected
    }
    
    @IBAction func notificationButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func handleSaloneData() {
        fetchAllSalons { (salons, error) in
            if let _ = error { } else {
                if let salons = salons {
                    DispatchQueue.main.async {
                        allSalonData = salons
                        self.sortSalonsForTopRated(salons)
                        self.mainCollectionView.reloadData()
                        self.ratedCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func sortSalonsForTopRated(_ salons: [SalonModel]) {
        let sortedSalons = salons.sorted { (salone1, salone2) -> Bool in
            if let rating1 = salone1.rating, let rating2 = salone2.rating {
                return rating1 > rating2
            } else if salone1.rating != nil {
                return true
            } else {
                return false
            }
        }
        topRatedSalons = sortedSalons
    }
    
    private func fetchAllSalons(completion: @escaping ([SalonModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let salonsCollectionRef = db.collection("salons")
        salonsCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var salons: [SalonModel] = []
                for document in querySnapshot!.documents {
                    do {
                        let salon = try document.data(as: SalonModel.self)
                        salons.append(salon)
                    } catch {
                        completion(nil, error)
                    }
                }
                completion(salons, nil)
            }
        }
    }
    
    private func hanleRtedCollectionViewItemCount() -> Int {
        if allSalonData.count >= 2 {
            return 2
        }
        return allSalonData.count
    }
    
    private func hanleMainCollectionViewItemCount() -> Int {
        if allSalonData.count >= 4 {
            return 4
        }
        return allSalonData.count
    }
    
    private func getCityStateFromCoordinates(_ location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            var addressString = ""
            if let city = placemark.locality {
                addressString += city
            }
            
            if let state = placemark.administrativeArea {
                if !addressString.isEmpty {
                    addressString += ", "
                }
                addressString += state
            }
            
            completion(addressString)
        }
    }
}
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ratedCollectionView {
            return ratedCollectionViewData ?? hanleRtedCollectionViewItemCount()
        }
        else if collectionView == catagoryCollectionView {
            return HomeServicesArray.count
        }
        return mainCollectionViewData ?? hanleMainCollectionViewItemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == ratedCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                let data = topRatedSalons[indexPath.row]
                cell.salonName.text = data.salonName
                cell.reviewCount.text = "\(data.reviews ?? 0) Reviews"
                cell.salonAddress.text = data.address
                
                if let url = data.image,
                   let profileUrl = URL(string: url) {
                    cell.salonImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.salonImage.sd_setImage(with: profileUrl,
                                                      placeholderImage: UIImage(named: "profilePic"))
                }
                else {
                    cell.salonImage.image = UIImage(named: "profilePic")
                }
                
                cell.starView.rating = data.rating ?? 0.0

                return cell
            }
        }
        else if collectionView == mainCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                let data = allSalonData[indexPath.row]
                cell.salonName.text = data.salonName
                cell.reviewCount.text = "\(data.reviews ?? 0) Reviews"
                cell.salonAddress.text = data.address
                
                if let url = data.image,
                   let profileUrl = URL(string: url) {
                    cell.salonImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.salonImage.sd_setImage(with: profileUrl,
                                                      placeholderImage: UIImage(named: "profilePic"))
                }
                else {
                    cell.salonImage.image = UIImage(named: "profilePic")
                }
                cell.starView.rating = data.rating ?? 0.0
                return cell
            }
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCatagoryCollectionCell", for: indexPath) as? HomeCatagoryCollectionCell {
                let data  = HomeServicesArray[indexPath.row]
                cell.serviceImage.image = UIImage(named: data.serviceImage) // No need for "\(data.serviceImage)"
                cell.serviceName.text = data.serviceName // No need for "\(data.serviceName)"
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ratedCollectionView {
            return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: mainCollectionView.frame.size.height)
        }
        else if collectionView == mainCollectionView {
            return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: collectionView.frame.size.height)
        }
        return CGSize(width: 60, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ratedCollectionView {
            let saloneData = allSalonData[indexPath.row]
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectserviceVC") as! SelectserviceVC
            nextVC.salonData = saloneData
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

