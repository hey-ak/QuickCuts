//
//  BookingCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

import UIKit

class BookingCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viewReceiptButton: UIButton!
    @IBOutlet weak var cancelServiceButton: UIButton!
    @IBOutlet weak var salonImage: UIImageView!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var salonAddress: UILabel!
    @IBOutlet weak var serviceID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
