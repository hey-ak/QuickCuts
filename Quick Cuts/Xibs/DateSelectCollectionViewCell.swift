import UIKit

class DateSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var date: Date = Date() {
        didSet {
            dayLabel.text = date.getDayFromDate()
            dateLabel.text = date.getMonthFromDate()
        }
    }
}
