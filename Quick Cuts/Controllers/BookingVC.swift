import UIKit



class BookingVC: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bookingCollectionView: UICollectionView!{
        didSet{
            bookingCollectionView.registerCellFromNib(cellID: "BookingCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCancelledCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCompletedCollectionCell")
        }
    }
    
    
    let currentData: [currentBookingDM] = [
        currentBookingDM(salonName: "Ramesh Salon", salonAddress: "SCO- 285, Ground Floor Sec, Sector 35D, Chandigarh, 160022", serviceID: "#0001", salonImage: "salonImage1"),
        currentBookingDM(salonName: "Suresh Salon", salonAddress: "ShopNo- 20, Press Road, Rajpura, 147003", serviceID: "#0002", salonImage: "salonImage2"),
        currentBookingDM(salonName: "Aone Salon", salonAddress: "101 Lane, Urban Estate Phase, Patiala, Punjab, India", serviceID: "#0003", salonImage: "salonImage3"),
        currentBookingDM(salonName: "Fresha Salon", salonAddress: "789 Avenue, Baradari Gardens, Patiala, Punjab, India", serviceID: "#0004", salonImage: "salonImage4"),
        currentBookingDM(salonName: "No.1 Salon", salonAddress: "777 Colony, Bhadson Road, Patiala, Punjab, India", serviceID: "#0005", salonImage: "salonImage5"),
        currentBookingDM(salonName: "Poonam Salon", salonAddress: "333 Road, Lehal Colony, Patiala, Punjab, India", serviceID: "#0006", salonImage: "salonImage6"),
        currentBookingDM(salonName: "Crazy Salon", salonAddress: "666 Lane, SST Nagar, Patiala, Punjab, India", serviceID: "#0007", salonImage: "salonImage7"),
    ]
    
    let completedData: [CompletedServicesDM] = [
        CompletedServicesDM(salonName: "Ramesh Salon", salonAddress: "SCO- 285, Ground Floor Sec, Sector 35D, Chandigarh, 160022", serviceID: "#0001", salonImage: "salonImage7"),
        CompletedServicesDM(salonName: "Suresh Salon", salonAddress: "ShopNo- 20, Press Road, Rajpura, 147003", serviceID: "#0002", salonImage: "salonImage6"),
        CompletedServicesDM(salonName: "Aone Salon", salonAddress: "101 Lane, Urban Estate Phase, Patiala, Punjab, India", serviceID: "#0003", salonImage: "salonImage5"),
        CompletedServicesDM(salonName: "Fresha Salon", salonAddress: "789 Avenue, Baradari Gardens, Patiala, Punjab, India", serviceID: "#0004", salonImage: "salonImage4"),
        CompletedServicesDM(salonName: "No.1 Salon", salonAddress: "777 Colony, Bhadson Road, Patiala, Punjab, India", serviceID: "#0005", salonImage: "salonImage3"),
        CompletedServicesDM(salonName: "Poonam Salon", salonAddress: "333 Road, Lehal Colony, Patiala, Punjab, India", serviceID: "#0006", salonImage: "salonImage2"),
        CompletedServicesDM(salonName: "Crazy Salon", salonAddress: "666 Lane, SST Nagar, Patiala, Punjab, India", serviceID: "#0007", salonImage: "salonImage1"),
    ]
    
    let cancelledData: [CancelledServicesDM] = [
        CancelledServicesDM(salonName: "Ramesh Salon", salonAddress: "SCO- 285, Ground Floor Sec, Sector 35D, Chandigarh, 160022", serviceID: "#0001", salonImage: "salonImage5"),
        CancelledServicesDM(salonName: "Suresh Salon", salonAddress: "ShopNo- 20, Press Road, Rajpura, 147003", serviceID: "#0002", salonImage: "salonImage7"),
        CancelledServicesDM(salonName: "Aone Salon", salonAddress: "101 Lane, Urban Estate Phase, Patiala, Punjab, India", serviceID: "#0003", salonImage: "salonImage1"),
        CancelledServicesDM(salonName: "Fresha Salon", salonAddress: "789 Avenue, Baradari Gardens, Patiala, Punjab, India", serviceID: "#0004", salonImage: "salonImage4"),
        CancelledServicesDM(salonName: "No.1 Salon", salonAddress: "777 Colony, Bhadson Road, Patiala, Punjab, India", serviceID: "#0005", salonImage: "salonImage3"),
        CancelledServicesDM(salonName: "Poonam Salon", salonAddress: "333 Road, Lehal Colony, Patiala, Punjab, India", serviceID: "#0006", salonImage: "salonImage6"),
        CancelledServicesDM(salonName: "Crazy Salon", salonAddress: "666 Lane, SST Nagar, Patiala, Punjab, India", serviceID: "#0007", salonImage: "salonImage2"),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        bookingCollectionView.reloadData()
    }
    
    @objc func buttonPressed(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CancelServiceVC") as! CancelServiceVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func ReceiptbuttonPressed(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
}



extension BookingVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSegment = segmentControl.selectedSegmentIndex
        switch currentSegment {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionCell", for: indexPath) as? BookingCollectionCell {
                
                cell.cancelServiceButton.addTarget(self, action: #selector(buttonPressed),for: .touchUpInside)
                cell.viewReceiptButton.addTarget(self, action: #selector(ReceiptbuttonPressed),for: .touchUpInside)
                let data = currentData[indexPath.row]
                cell.salonName.text = data.salonName
                cell.salonImage.image = UIImage(named: "\(data.salonImage)")
                //cell.serviceID.text = "\(data.serviceID)"
                cell.salonAddress.text = data.salonAddress
                return cell
                
            }
            
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCompletedCollectionCell", for: indexPath) as? BookingCompletedCollectionCell {
                let data = completedData[indexPath.row]
                cell.salonName.text = data.salonName
                cell.salonImage.image = UIImage(named: "\(data.salonImage)")
                //cell.serviceID.text = "\(data.serviceID)"
                cell.salonAddress.text = data.salonAddress
                return cell
            }
            
        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCancelledCollectionCell", for: indexPath) as? BookingCancelledCollectionCell {
                let data = cancelledData[indexPath.row]
                cell.salonName.text = data.salonName
                cell.salonImage.image = UIImage(named: "\(data.salonImage)")
                //cell.serviceID.text = "\(data.serviceID)"
                cell.salonAddress.text = data.salonAddress
                return cell
            }
            
        default:break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width * 243) / 362
       return CGSize(width: collectionView.frame.size.width, height: side)
    }
}



