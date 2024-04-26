import UIKit

class SelectserviceVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?
    
    
    @IBOutlet weak var serviceCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceCollectionView: UICollectionView! {
        didSet {
            serviceCollectionView.registerCellFromNib(cellID: "ServiceCollectionCell")
            contentSizeObservation = serviceCollectionView.observe(\.contentSize, options: [.new]) { [weak self] serviceCollectionView, change in
                self?.serviceCollectionView.invalidateIntrinsicContentSize()
                self?.serviceCollectionHeightConstraint.constant = serviceCollectionView.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    
    @IBOutlet weak var imageStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectDateAndTimeDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension SelectserviceVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionCell", for: indexPath) as! ServiceCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 40) / 3
        return CGSize(width:  side, height: side)
    }
}
