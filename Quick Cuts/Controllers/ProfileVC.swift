//
//  ProfileVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 23/04/24.
//

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
        // guard section > 0 else { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummyTableCell") as! dummyTableCell
        return cell.contentView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileDM.count
    }
}
