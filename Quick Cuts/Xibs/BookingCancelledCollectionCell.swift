//
//  BookingCancelledCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

import UIKit

class BookingCancelledCollectionCell: UICollectionViewCell {

    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var salonImage: UIImageView!
    @IBOutlet weak var salonAddress: UILabel!
    @IBOutlet weak var serviceID: UILabel!
    @IBOutlet weak var reBookButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
