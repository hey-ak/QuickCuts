//
//  profileHeadTableCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 26/04/24.
//

import UIKit

class profileHeadTableCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
