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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as! ProfileTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
