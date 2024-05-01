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
                self.ratedCollectionViewData = 10
                
            case .unselected:
                self.ratedCollectionViewData = nil
            }
        }
    }
    
    private var mainCollectionSeeAllState:SeeAllState = .unselected {
        didSet {
            switch mainCollectionSeeAllState {
            case .selected:
                self.mainCollectionViewData = 10
                
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
    
    let HomeArray: [HomeCard] = [
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


    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ratedCollectionSeeAllState = .unselected
        mainCollectionSeeAllState = .unselected
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
            return HomeArray.count
        }
        return mainCollectionViewData ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ratedCollectionView || collectionView == mainCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
                let data = HomeArray[indexPath.row]
                cell.salonName.text = data.salonName
                cell.salonImage.image = UIImage(named: "\(data.salonImage)")
                cell.reviewCount.text = "\(data.reviewCount) Reviews"
                //cell.serviceID.text = "\(data.serviceID)"
                cell.salonAddress.text = data.salonAddress
                return cell
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCatagoryCollectionCell", for: indexPath) as? HomeCatagoryCollectionCell {
            return cell
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
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectserviceVC") as! SelectserviceVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
