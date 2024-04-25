//
//  SignUpVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 25/04/24.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        GoToHomeVC()
    }
    
    @IBAction func alradyMemeberDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
