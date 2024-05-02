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
    
    let timeSlotData: [BookingTimeSlot] = [
        BookingTimeSlot(timeSlot: "09:00 AM"),
        BookingTimeSlot(timeSlot: "09:30 AM"),
        BookingTimeSlot(timeSlot: "10:00 AM"),
        BookingTimeSlot(timeSlot: "10:30 AM"),
        BookingTimeSlot(timeSlot: "11:00 AM"),
        BookingTimeSlot(timeSlot: "11:30 AM"),
        BookingTimeSlot(timeSlot: "12:00 PM"),
        BookingTimeSlot(timeSlot: "12:30 PM"),
        BookingTimeSlot(timeSlot: "01:00 PM"),
        BookingTimeSlot(timeSlot: "01:30 PM"),
        BookingTimeSlot(timeSlot: "02:00 PM"),
        BookingTimeSlot(timeSlot: "02:30 PM"),
        BookingTimeSlot(timeSlot: "03:00 PM"),
        BookingTimeSlot(timeSlot: "03:30 PM"),
        BookingTimeSlot(timeSlot: "04:00 PM"),
    ]
    
    let dayAndDateData: [DayAndDateDM] = [
        DayAndDateDM(dayLabel: "MON", dateLabel: "05"),
        DayAndDateDM(dayLabel: "TUE", dateLabel: "06"),
        DayAndDateDM(dayLabel: "WED", dateLabel: "07"),
        DayAndDateDM(dayLabel: "THU", dateLabel: "08"),
        DayAndDateDM(dayLabel: "FRI", dateLabel: "09"),
        DayAndDateDM(dayLabel: "SAT", dateLabel: "10"),
        DayAndDateDM(dayLabel: "SUN", dateLabel: "11")
    ]


    
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
            return dayAndDateData.count
        }
        else {
            return timeSlotData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == DayAndDateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateSelectCollectionViewCell", for: indexPath) as! DateSelectCollectionViewCell
            let data = dayAndDateData[indexPath.row]
            cell.dateLabel.text = data.dateLabel
            cell.dayLabel.text = data.dayLabel
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionCell", for: indexPath) as! TimeSlotCollectionCell
            let data = timeSlotData[indexPath.row]
            cell.timeSlot.text = data.timeSlot
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

