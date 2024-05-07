
import UIKit

class ReceiptVC: UIViewController {
    private var contentSizeObservation:NSKeyValueObservation?
    @IBOutlet weak var receiptTableView: UITableView!{
        
        didSet{
            receiptTableView.registerCellFromNib(cellID: "CheckoutTableViewCell")
            
        }
    }
    
//    @IBOutlet weak var heightobserver: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        receiptTableView.sectionHeaderTopPadding = 0
    }
    


}

extension ReceiptVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
//        return cell
        
        
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
//            let data = profileDM[indexPath.section].profileData[indexPath.row]
//            cell.userName.text = data.userProfileDetails?.userName
//            cell.userPhoneNumber.text = data.userProfileDetails?.phoneNumber
//            cell.userProfileImage.image = UIImage(named: data.userProfileDetails?.userImage ?? "profilePic")
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == profileDM[section].profileData.count - 1 {
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else {
                cell.contentView.layer.maskedCorners = []
                cell.contentView.layer.cornerRadius = 0
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
//            let data = profileDM[indexPath.section].profileData[indexPath.row]
//            cell.profileLabel.text = data.profileOption.rawValue
//            cell.profileIcon.image = UIImage(named: data.profileOption.rawValue)
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == profileDM[section].profileData.count - 1 {
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else {
                cell.contentView.layer.maskedCorners = []
                cell.contentView.layer.cornerRadius = 0
            }
            
            return cell
        default : return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section >= 0 else { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummyTableCell") as? dummyTableCell
        
        guard let validCell = cell else {
            let newCell = dummyTableCell()
            return newCell.contentView
        }
        
        return validCell.contentView
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    
    
}
