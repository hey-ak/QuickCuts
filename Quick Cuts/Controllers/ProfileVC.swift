//
//  ProfileVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 23/04/24.
//

import UIKit

class ProfileVC: UIViewController {
    
    let profileData = [
        ["Your Profile", "Payment Method", "Favourities", "Transactions"],
        ["Settings", "Help Centre", "Privacy Policy", "Log-out"],
        ]

    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            profileTableView.registerCellFromNib(cellID: "ProfileTableCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
        cell.profileLabel?.text = profileData[indexPath.section][indexPath.row]
        //cell.backgroundColor = .red
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}
