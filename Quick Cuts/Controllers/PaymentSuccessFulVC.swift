

import UIKit

class PaymentSuccessFulVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
            nextVC.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        }

    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
