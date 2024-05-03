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

let notificationArray: [Notification] = [
    Notification(name: "Ramesh Salon", message: "Your appointment scheduled for tomorrow has been cancelled.", time: "9:30 AM"),
    Notification(name: "Suresh Salon", message: "Due to unforeseen circumstances, your appointment has been cancelled.", time: "10:45 AM"),
    Notification(name: "Aone Salon", message: "We regret to inform you that your appointment has been cancelled.", time: "11:15 AM"),
    Notification(name: "Fresha Salon", message: "Your booking has been cancelled as the stylist is unavailable.", time: "12:00 PM"),
    Notification(name: "No.1 Salon", message: "We apologize for the inconvenience, but your appointment has been cancelled.", time: "1:30 PM"),
    Notification(name: "Poonam Salon", message: "Your appointment for the day has been cancelled due to technical issues.", time: "2:45 PM"),
    Notification(name: "Crazy Salon", message: "We're sorry to inform you that your appointment has been cancelled.", time: "3:20 PM"),
    Notification(name: "Ramesh Salon", message: "Due to unexpected circumstances, your appointment has been cancelled.", time: "4:00 PM"),
    Notification(name: "Suresh Salon", message: "Unfortunately, your booking has been cancelled. We apologize for any inconvenience caused.", time: "5:00 PM"),
    Notification(name: "Aone Salon", message: "Your appointment has been cancelled. Please reschedule at your convenience.", time: "6:00 PM")
]


extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let data = notificationArray[indexPath.row]
        cell.notificationName.text = data.name
        cell.notificationTime.text = data.time
        cell.notificationMessage.text = data.message
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
