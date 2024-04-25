//
//  ProfileVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 23/04/24.
//

import UIKit

class ProfileVC: UIViewController {
    
    let profileData = [
        ["Neeraj"],
        ["Your Profile", "Payment Method", "Favourities", "Transactions"],
        ["Settings", "Help Centre", "Privacy Policy", "Log-out"],
        ]

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
        profileData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeadTableCell", for: indexPath) as! profileHeadTableCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            cell.profileLabel?.text = profileData[indexPath.section][indexPath.row]
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == profileData[section].count - 1 {
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
            cell.profileLabel?.text = profileData[indexPath.section][indexPath.row]
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == profileData[section].count - 1 {
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
        3
    }
}
