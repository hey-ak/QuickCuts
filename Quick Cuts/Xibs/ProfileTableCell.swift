

import UIKit

class ProfileTableCell: UITableViewCell {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
