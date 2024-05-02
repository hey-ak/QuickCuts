//
//  CancelServiceCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 23/04/24.
//

import UIKit

class CancelServiceCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func cancelFeedbackButtonDidTapped(_ sender: Any) {
        //cancelButton.backgroundColor = .blue
    }
}


