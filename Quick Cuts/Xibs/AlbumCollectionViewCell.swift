//
//  AlbumCollectionViewCell.swift
//  Quick Cuts
//
//  Created by Akshat Gulati on 25/04/24.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var Album: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumPhotosNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
