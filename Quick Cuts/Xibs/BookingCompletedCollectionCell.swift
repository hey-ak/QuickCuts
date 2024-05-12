import UIKit

class BookingCompletedCollectionCell: UICollectionViewCell {

    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var salonImage: UIImageView!
    @IBOutlet weak var salonAddress: UILabel!
    @IBOutlet weak var servviceId: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
