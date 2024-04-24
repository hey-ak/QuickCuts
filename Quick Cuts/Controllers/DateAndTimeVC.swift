//
//  DateAndTimeVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 24/04/24.
//

import UIKit

class DateAndTimeVC: UIViewController {

    @IBOutlet weak var DayAndDateCollectionView: UICollectionView! {
        didSet {
            DayAndDateCollectionView.registerCellFromNib(cellID: "DateSelectCollectionViewCell")
        }
    }
    
    @IBOutlet weak var TimeSlotCollectionView: UICollectionView! {
        didSet {
            TimeSlotCollectionView.registerCellFromNib(cellID: "TimeSlotCollectionCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}


extension DateAndTimeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == DayAndDateCollectionView {
            return 7
        }
        else {
            return 100
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
            let width = ( collectionView.frame.width - 30 ) / 4
            let height = ( collectionView.frame.height ) / 1
            return CGSize(width: width, height: height)
        }
        else {
            let width = ( collectionView.frame.width ) / 3
//            let height = ( collectionView.frame.height ) / 4
            return CGSize(width: width, height: width)
        }
    }
    
}

