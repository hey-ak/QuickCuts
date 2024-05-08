import UIKit

class SelectserviceVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?
    private var textViewContentSizeObservation:NSKeyValueObservation?
    private var selectedIndexPaths = [IndexPath]()
    
    public var salonData:SalonModel?
    private var serviceData = [SalonServices]() {
        didSet {
            serviceCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saloneImage: UIImageView!
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
    @IBOutlet weak var aboutTextView: UITextView!{
        didSet {
            textViewContentSizeObservation = aboutTextView.observe(\.contentSize, options: [.new]) { [weak self] aboutTextView, change in
                self?.aboutTextView.invalidateIntrinsicContentSize()
                self?.textViewHeightConstraint.constant = aboutTextView.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populateSalonData(salonData)
    }

    @IBAction func selectDateAndTimeDidTapped(_ sender: Any) {
        guard selectedIndexPaths.count > 0 else {
            showToast("Please select any service.")
            return }
        var services = [SalonServices]()
        
        for (index,service) in serviceData.enumerated() {
            for selectedIndex in selectedIndexPaths {
                if selectedIndex.row == index {
                    services.append(service)
                    break
                }
            }
        }
        
        guard services.count > 0 else {
            showToast("Please select any service.")
            return }
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        nextVC.serviceData = services
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showToast(_ message:String) {
        DispatchQueue.main.async {
            let toast = Toast.default(
                image: UIImage(named: "mark")!,
                title: message
            )
            toast.show()
        }
    }
    
    private func populateSalonData(_ salonData:SalonModel?) {
        guard let saloneData = salonData else { return }
        if let serviceData = saloneData.services {
            self.serviceData = serviceData
        }
        aboutTextView.text = saloneData.about
        salonName.text = salonData?.salonName
        saloneImage.image = UIImage(named: saloneData.image ?? "")
    }
}
extension SelectserviceVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionCell", for: indexPath) as! ServiceCollectionCell
        let data = serviceData[indexPath.row]
        cell.serviceName.text = data.serviceName
        cell.servicePrice.text = "Rs: \(data.servicePrice ?? 0)"
        if selectedIndexPaths.contains(indexPath) {
            cell.mainView.backgroundColor = UIColor(named: "EC6E57")
            cell.serviceName.textColor = .white
            cell.servicePrice.textColor = .white
        }
        else {
            cell.mainView.backgroundColor = UIColor(named: "D5D5D5")
            cell.serviceName.textColor = .black
            cell.servicePrice.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 40) / 3
        return CGSize(width:  side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelection(indexPath)
    }
    
    private func handleSelection(_ indexPath:IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
                selectedIndexPaths.remove(at: index)
            }
            else {
                selectedIndexPaths.append(indexPath)
            }
        }
        else {
            selectedIndexPaths.append(indexPath)
        }
        serviceCollectionView.reloadData()
    }
}
