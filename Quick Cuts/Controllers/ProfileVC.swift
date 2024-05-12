import UIKit
import SDWebImage
import FirebaseAuth
import YPImagePicker

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
            let userProfile = AppDataManager.shared.loadUserProfile()
           

            if let url = userProfile?.profile,
               let profileUrl = URL(string: url) {
                cell.userProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userProfileImage.sd_setImage(with: profileUrl,
                                                  placeholderImage: UIImage(named: "profilePic"))
            }
            else {
                cell.userProfileImage.image = UIImage(named: "profilePic")
            }
            
            cell.userName.text = userProfile?.name
            cell.userPhoneNumber.text = userProfile?.phoneNumber
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
        else if indexPath.section == 0, indexPath.row == 0 {
            openImagePicker()
        }
    }
}
extension ProfileVC {
    
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
    
    private func openImagePicker() {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                DispatchQueue.main.async {
                    self.showChangeProfileImageAlert(photo.originalImage)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    private func showChangeProfileImageAlert(_ newImage:UIImage) {
        let alertController = UIAlertController(title: "Change Profile Image",
                                                message: "Are you sure you want to change your profile image?",
                                                preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm",
                                          style: .default) { [weak self] (_) in
            
            self?.changeProfileImage(newImage)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func changeProfileImage(_ newImage:UIImage) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        AppDataManager.shared.uploadProfileImage(newImage, for: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageURL):
                    self.fetchAndSaveProfile()
                case .failure(let error):
                    self.showToast("Profile image updation failed.")
                }
            }
        }
    }
    
    public func fetchAndSaveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        AppDataManager.shared.fetchUserProfile(for: userId) { result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    AppDataManager.shared.saveUserProfile(userProfile)
                    AppDataManager.shared.saveLoggedUserID(userId)
                    self.showToast("Profile image updated sucessfully.")
                    self.profileTableView.reloadData()
                }
                
            default:break
            }
        }
    }
}
