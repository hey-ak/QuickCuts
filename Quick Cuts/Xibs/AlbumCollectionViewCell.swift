

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
