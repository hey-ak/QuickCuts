

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationName: UILabel!
    
 
    @IBOutlet weak var notificationTime: UILabel!
    
    @IBOutlet weak var notificationMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
