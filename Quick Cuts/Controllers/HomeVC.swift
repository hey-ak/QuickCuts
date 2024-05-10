import UIKit
import FirebaseFirestoreInternal
import FirebaseCore

enum SeeAllState {
    case selected
    case unselected
}

class HomeVC: UIViewController {
    
    
    private var contentSizeObservation:NSKeyValueObservation?
    
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
                self.ratedCollectionViewData = allSalonData.count
                
            case .unselected:
                self.ratedCollectionViewData = nil
            }
        }
    }
    
    private var mainCollectionSeeAllState:SeeAllState = .unselected {
        didSet {
            switch mainCollectionSeeAllState {
            case .selected:
                self.mainCollectionViewData = FavouriteCardArray.count
                
            case .unselected:
                self.mainCollectionViewData = nil
            }
        }
    }
    
    
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
    
    let HomeCardArray: [HomeCard] = [ ]
    
    let HomeServicesArray: [HomeServices] = [
        HomeServices(serviceImage: "serviceImage1", serviceName: "HairCut"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Pedicure"),
        HomeServices(serviceImage: "serviceImage2", serviceName: "Massage"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Facial"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Hair Coloring"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Shaving"),
    ]
    
    

    let FavouriteCardArray: [FavouriteCard] = [ ]

    override func viewDidLoad() {
        super.viewDidLoad()
        ratedCollectionSeeAllState = .unselected
        mainCollectionSeeAllState = .unselected
        catagoryCollectionView.reloadData()
        
        
        
        fetchAllSalons { (salons, error) in
            if let error = error {
                // Handle error
                print("Error fetching salons: \(error.localizedDescription)")
            } else {
                if let salons = salons {
                    DispatchQueue.main.async {
                        allSalonData = salons
                        self.mainCollectionView.reloadData()
                        self.ratedCollectionView.reloadData()
                    }
                    
                } else {
                    // Handle nil result
                    print("No salons found")
                }
            }
        }
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
    
    public func fetchAllSalons(completion: @escaping ([SalonModel]?, Error?) -> Void) {
        var db = Firestore.firestore()
        let salonsCollectionRef = db.collection("salons")
        
        // Fetch all documents from the collection
        salonsCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle error
                completion(nil, error)
            } else {
                var salons: [SalonModel] = []
                // Iterate through documents
                for document in querySnapshot!.documents {
                    do {
                        // Try to decode each document into a SalonModel object
                        let salon = try! document.data(as: SalonModel.self)
                        salons.append(salon)
                    } catch {
                        // Handle decoding error
                        completion(nil, error)
                    }
                }
                // Completion with the array of SalonModel objects
                completion(salons, nil)
            }
        }
    }
}
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ratedCollectionView {
            return allSalonData.count
        }
        else if collectionView == catagoryCollectionView {
            return HomeServicesArray.count
        }
        return allSalonData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == ratedCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                    let data = allSalonData[indexPath.row]
                    cell.salonName.text = data.salonName
                    cell.salonImage.image = UIImage(named: data.image ?? "favouriteImage4") // No need for "\(data.salonImage)"
                    cell.reviewCount.text = "\(data.reviews ?? 0) Reviews"
                    //cell.serviceID.text = "\(data.serviceID)"
                    cell.salonAddress.text = data.address
                    return cell
                }
            }
        else if collectionView == mainCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                let data = allSalonData[indexPath.row]
                cell.salonName.text = data.salonName
                cell.salonImage.image = UIImage(named: data.image ?? "favouriteImage4") // No need for "\(data.salonImage)"
                cell.reviewCount.text = "\(data.reviews ?? 0) Reviews"
                //cell.serviceID.text = "\(data.serviceID)"
                cell.salonAddress.text = data.address
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
