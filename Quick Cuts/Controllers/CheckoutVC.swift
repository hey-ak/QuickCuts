
import UIKit

class CheckoutVC: UIViewController {
    private var contentSizeObservation:NSKeyValueObservation?
    @IBOutlet weak var checkout: UITableView!{
        
        didSet{
            checkout.registerCellFromNib(cellID: "CheckoutTableViewCell")
//            contentSizeObservation = checkout.observe(\.contentSize, options: [.new]) { [weak self] checkout, change in
//                self?.checkout.invalidateIntrinsicContentSize()
//                self?.heightobserver.constant = checkout.contentSize.height
//                self?.view.layoutIfNeeded()
//            }
            
        }
    }
    
//    @IBOutlet weak var heightobserver: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkout.sectionHeaderTopPadding = 0
    }
    


}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section >= 0 else { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummyTableCell") as? dummyTableCell
        
        guard let validCell = cell else {
            let newCell = dummyTableCell()
            return newCell.contentView
        }
        
        return validCell.contentView
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    
    
}
