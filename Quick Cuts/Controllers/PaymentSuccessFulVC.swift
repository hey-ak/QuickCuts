//
//  PaymentSuccessFulVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 26/04/24.
//

import UIKit

class PaymentSuccessFulVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
