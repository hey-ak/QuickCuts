//
//  NotificationVC.swift
//  Quick Cuts
//
//  Created by Akshay Jha on 24/04/24.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!{
        didSet {
            notificationTableView.registerCellFromNib(cellID: "NotificationTableViewCell")
            notificationTableView.registerCellFromNib(cellID: "NotificationHeaderCell")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    


}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationHeaderCell") as! NotificationHeaderCell
        return cell.contentView
    }
    
}
