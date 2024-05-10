import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            profileTableView.registerCellFromNib(cellID: "ProfileTableCell")
            profileTableView.registerCellFromNib(cellID: "dummyTableCell")
            profileTableView.registerCellFromNib(cellID: "profileHeadTableCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.sectionHeaderTopPadding = 0
    }
}
extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileDM[section].profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeadTableCell", for: indexPath) as! profileHeadTableCell
            let data = profileDM[indexPath.section].profileData[indexPath.row]
            cell.userName.text = data.userProfileDetails?.userName
            cell.userPhoneNumber.text = data.userProfileDetails?.phoneNumber
            cell.userProfileImage.image = UIImage(named: data.userProfileDetails?.userImage ?? "profilePic")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            let data = profileDM[indexPath.section].profileData[indexPath.row]
            cell.profileLabel.text = data.profileOption.rawValue
            cell.profileIcon.image = UIImage(named: data.profileOption.rawValue)
            
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            let data = profileDM[indexPath.section].profileData[indexPath.row]
            cell.profileLabel.text = data.profileOption.rawValue
            cell.profileIcon.image = UIImage(named: data.profileOption.rawValue)
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummyTableCell") as! dummyTableCell
        return cell.contentView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileDM.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 3 {
            showLogoutAlert()
        }
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(title: "Logout",
                                                message: "Are you sure you want to log out?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) {[weak self] (action) in
            DispatchQueue.main.async {
                self?.logout()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func logout() {
        let result = AppDataManager.shared.logoutUser()
        DispatchQueue.main.async {
            if case let .failure(error) = result {
                switch error {
                case .signOutFailed(let reason):
                    self.showToast(reason)
                }
            }
            else {
                GoToSigninVC()
            }
        }
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
}
