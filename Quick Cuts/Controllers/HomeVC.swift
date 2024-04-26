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
                self.ratedCollectionViewData = 20
                
            case .unselected:
                self.ratedCollectionViewData = nil
            }
        }
    }
    
    private var mainCollectionSeeAllState:SeeAllState = .unselected {
        didSet {
            switch mainCollectionSeeAllState {
            case .selected:
                self.mainCollectionViewData = 20
                
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
            return ratedCollectionViewData ?? 2
        }
        else if collectionView == catagoryCollectionView {
            return 20
        }
        return mainCollectionViewData ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ratedCollectionView || collectionView == mainCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell {
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
