
import UIKit

class CancelServiceVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?

    @IBOutlet weak var cancelReasonCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelServiceCollectionViewOutlet: UICollectionView! {
        didSet{
            cancelServiceCollectionViewOutlet.registerCellFromNib(cellID: "CancelServiceCollectionCell")
            contentSizeObservation = cancelServiceCollectionViewOutlet.observe(\.contentSize, options: [.new]) { [weak self] cancelServiceCollectionViewOutlet, change in
                self?.cancelServiceCollectionViewOutlet.invalidateIntrinsicContentSize()
                self?.cancelReasonCollectionViewHeightConstraint.constant = cancelServiceCollectionViewOutlet.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    let salonCancelReasons: [cancelReason] = [
        cancelReason(cancelServiceReason: "Not needed"),
        cancelReason(cancelServiceReason: "Bad Service"),
        cancelReason(cancelServiceReason: "Sickness"),
        cancelReason(cancelServiceReason: "Not satisfied"),
        cancelReason(cancelServiceReason: "Budget issue"),
        cancelReason(cancelServiceReason: "Better offer"),
        cancelReason(cancelServiceReason: "Unexpected"),
        cancelReason(cancelServiceReason: "Personal"),
        cancelReason(cancelServiceReason: "Unavailable"),
        // Add more concise reasons as needed
    ]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationController?.navigationBar.prefersLargeTitles = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.navigationBar.prefersLargeTitles = false
    }

}

extension CancelServiceVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        salonCancelReasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CancelServiceCollectionCell", for: indexPath) as! CancelServiceCollectionCell
        let data = salonCancelReasons[indexPath.row]
        cell.cancelServiceReasonButton.text = data.cancelServiceReason
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let b = ( collectionView.layer.frame.width - 30 ) / 3
        let l = ( collectionView.layer.frame.width - 30 ) / 3
        return CGSize(width: b, height: l)
    }
}
