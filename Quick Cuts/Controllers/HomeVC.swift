import UIKit

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
    
    let HomeCardArray: [HomeCard] = [
        HomeCard(salonName: "Ramesh Salon", salonAddress: "SCO- 285, Ground Floor Sec, Sector 35D, Chandigarh, 160022", reviewCount: 10, salonImage: "salonImage1"),
        HomeCard(salonName: "Anita's Beauty Salon", salonAddress: "123 Main Street, Cityville, XYZ", reviewCount: 15, salonImage: "salonImage2"),
        HomeCard(salonName: "Glamour World Salon", salonAddress: "789 Elm Street, Townsville, ABC", reviewCount: 20, salonImage: "salonImage3"),
        HomeCard(salonName: "Style Diva Salon", salonAddress: "456 Oak Avenue, Villagetown, DEF", reviewCount: 8, salonImage: "salonImage4"),
        HomeCard(salonName: "Elegance Salon & Spa", salonAddress: "101 Pine Road, Hamletville, GHI", reviewCount: 12, salonImage: "salonImage5"),
        HomeCard(salonName: "Radiance Hair Studio", salonAddress: "876 Maple Lane, Boroughburg, JKL", reviewCount: 18, salonImage: "salonImage6"),
        HomeCard(salonName: "Chic Beauty Lounge", salonAddress: "543 Cedar Court, Township, MNO", reviewCount: 6, salonImage: "salonImage7"),
        HomeCard(salonName: "Serenity Spa & Salon", salonAddress: "222 Walnut Drive, County, PQR", reviewCount: 25, salonImage: "salonImage8"),
        HomeCard(salonName: "Blissful Beauty Haven", salonAddress: "999 Pineapple Street, District, STU", reviewCount: 9, salonImage: "salonImage9"),
        HomeCard(salonName: "Tranquility Wellness Center", salonAddress: "777 Waterfall Road, Precinct, VWX", reviewCount: 14, salonImage: "salonImage10")
    ]
    
    let HomeServicesArray: [HomeServices] = [
        HomeServices(serviceImage: "serviceImage1", serviceName: "HairCut"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Pedicure"),
        HomeServices(serviceImage: "serviceImage2", serviceName: "Massage"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Facial"),
        HomeServices(serviceImage: "serviceImage3", serviceName: "Hair Coloring"),
        HomeServices(serviceImage: "serviceImage5", serviceName: "Shaving"),
    ]
    
    

    let FavouriteCardArray: [FavouriteCard] = [
        FavouriteCard(salonName: "Glamour Hair & Beauty", salonAddress: "123 Park Street, Springfield, ABC", reviewCount: 30, salonImage: "favouriteImage1"),
        FavouriteCard(salonName: "Chic Style Studio", salonAddress: "456 Elm Avenue, Rivertown, DEF", reviewCount: 22, salonImage: "favouriteImage2"),
        FavouriteCard(salonName: "Elegant Touch Spa", salonAddress: "789 Maple Road, Lakeside, GHI", reviewCount: 35, salonImage: "favouriteImage3"),
        FavouriteCard(salonName: "Luxe Beauty Lounge", salonAddress: "101 Cedar Lane, Hillcrest, JKL", reviewCount: 28, salonImage: "favouriteImage4"),
        FavouriteCard(salonName: "Tranquil Retreat", salonAddress: "876 Oak Street, Meadowland, MNO", reviewCount: 40, salonImage: "favouriteImage5")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        ratedCollectionSeeAllState = .unselected
        mainCollectionSeeAllState = .unselected
        catagoryCollectionView.reloadData()
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
}
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ratedCollectionView {
            return ratedCollectionViewData ?? 4
        }
        else if collectionView == catagoryCollectionView {
            return HomeServicesArray.count
        }
        return mainCollectionViewData ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == ratedCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                    let data = allSalonData[indexPath.row]
                    cell.salonName.text = data.salonName
                    cell.salonImage.image = UIImage(named: data.image ?? "") // No need for "\(data.salonImage)"
                    cell.reviewCount.text = "\(data.reviews ?? 0) Reviews"
                    //cell.serviceID.text = "\(data.serviceID)"
                    cell.salonAddress.text = data.address
                    return cell
                }
            }
        else if collectionView == mainCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                    let data = FavouriteCardArray[indexPath.row]
                    cell.salonName.text = data.salonName
                    cell.salonImage.image = UIImage(named: data.salonImage) // No need for "\(data.salonImage)"
                    cell.reviewCount.text = "\(data.reviewCount) Reviews"
                    //cell.serviceID.text = "\(data.serviceID)"
                    cell.salonAddress.text = data.salonAddress
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
