//
//  PaymentVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 26/04/24.
//

import UIKit

class PaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func proceedToCheckOutButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessFulVC") as! PaymentSuccessFulVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
