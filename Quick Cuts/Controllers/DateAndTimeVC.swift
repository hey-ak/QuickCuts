//
//  DateAndTimeVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 24/04/24.
//

import UIKit

class DateAndTimeVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?

    @IBOutlet weak var DayAndDateCollectionView: UICollectionView! {
        didSet {
            DayAndDateCollectionView.registerCellFromNib(cellID: "DateSelectCollectionViewCell")
        }
    }
    
    @IBOutlet weak var TimeSlotCollectionView: UICollectionView! {
        didSet {
            TimeSlotCollectionView.registerCellFromNib(cellID: "TimeSlotCollectionCell")
            contentSizeObservation = TimeSlotCollectionView.observe(\.contentSize, options: [.new]) { [weak self] TimeSlotCollectionView, change in
                self?.TimeSlotCollectionView.invalidateIntrinsicContentSize()
                self?.timeSlotHeightObserver.constant = TimeSlotCollectionView.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet weak var timeSlotHeightObserver: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func paymentMethodButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    

}


extension DateAndTimeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == DayAndDateCollectionView {
            return 7
        }
        else {
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == DayAndDateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateSelectCollectionViewCell", for: indexPath) as! DateSelectCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionCell", for: indexPath) as! TimeSlotCollectionCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == DayAndDateCollectionView {
            let width = ( collectionView.frame.width - 75 ) / 4
            return CGSize(width: width, height: collectionView.frame.height)
        }
        else {
            let width = ( collectionView.frame.width - 30 ) / 3
            let height = (43 * width) / 107
            return CGSize(width: width, height: height)
        }
    }
    
}

