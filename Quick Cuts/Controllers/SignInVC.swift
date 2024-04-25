//
//  SignInVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 25/04/24.
//

import UIKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonDidTapped(_ sender: Any) {
        GoToHomeVC()
    }
    
    @IBAction func dontHaveAccButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
