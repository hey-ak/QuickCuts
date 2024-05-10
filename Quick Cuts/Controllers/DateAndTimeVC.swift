import UIKit

class DateAndTimeVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?
    public var serviceData = [SalonServices]()
    private var dates = [Date]()
    private var activeIndexPath :IndexPath? = nil
    private var selectedIndexPaths = [IndexPath]()
    private var selectedSlotes = [Int]()
    private var mySlotSelection = [IndexPath]()
    public var salonData:SalonModel?
    
    
    let timeSlotData: [BookingTimeSlot] = [
        BookingTimeSlot(id: 1, timeSlot: "12:00 AM"),
        BookingTimeSlot(id: 2, timeSlot: "12:30 AM"),
        BookingTimeSlot(id: 3, timeSlot: "01:00 AM"),
        BookingTimeSlot(id: 4, timeSlot: "01:30 AM"),
        BookingTimeSlot(id: 5, timeSlot: "02:00 AM"),
        BookingTimeSlot(id: 6, timeSlot: "02:30 AM"),
        BookingTimeSlot(id: 7, timeSlot: "03:00 AM"),
        BookingTimeSlot(id: 8, timeSlot: "03:30 AM"),
        BookingTimeSlot(id: 9, timeSlot: "04:00 AM"),
        BookingTimeSlot(id: 10, timeSlot: "04:30 AM"),
        BookingTimeSlot(id: 11, timeSlot: "05:00 AM"),
        BookingTimeSlot(id: 12, timeSlot: "05:30 AM"),
        BookingTimeSlot(id: 13, timeSlot: "06:00 AM"),
        BookingTimeSlot(id: 14, timeSlot: "06:30 AM"),
        BookingTimeSlot(id: 15, timeSlot: "07:00 AM"),
        BookingTimeSlot(id: 16, timeSlot: "07:30 AM"),
        BookingTimeSlot(id: 17, timeSlot: "08:00 AM"),
        BookingTimeSlot(id: 18, timeSlot: "08:30 AM"),
        BookingTimeSlot(id: 19, timeSlot: "09:00 AM"),
        BookingTimeSlot(id: 20, timeSlot: "09:30 AM"),
        BookingTimeSlot(id: 21, timeSlot: "10:00 AM"),
        BookingTimeSlot(id: 22, timeSlot: "10:30 AM"),
        BookingTimeSlot(id: 23, timeSlot: "11:00 AM"),
        BookingTimeSlot(id: 24, timeSlot: "11:30 AM"),
        BookingTimeSlot(id: 25, timeSlot: "12:00 PM"),
        BookingTimeSlot(id: 26, timeSlot: "12:30 PM"),
        BookingTimeSlot(id: 27, timeSlot: "01:00 PM"),
        BookingTimeSlot(id: 28, timeSlot: "01:30 PM"),
        BookingTimeSlot(id: 29, timeSlot: "02:00 PM"),
        BookingTimeSlot(id: 30, timeSlot: "02:30 PM"),
        BookingTimeSlot(id: 31, timeSlot: "03:00 PM"),
        BookingTimeSlot(id: 32, timeSlot: "03:30 PM"),
        BookingTimeSlot(id: 33, timeSlot: "04:00 PM"),
        BookingTimeSlot(id: 34, timeSlot: "04:30 PM"),
        BookingTimeSlot(id: 35, timeSlot: "05:00 PM"),
        BookingTimeSlot(id: 36, timeSlot: "05:30 PM"),
        BookingTimeSlot(id: 37, timeSlot: "06:00 PM"),
        BookingTimeSlot(id: 38, timeSlot: "06:30 PM"),
        BookingTimeSlot(id: 39, timeSlot: "07:00 PM"),
        BookingTimeSlot(id: 40, timeSlot: "07:30 PM"),
        BookingTimeSlot(id: 41, timeSlot: "08:00 PM"),
        BookingTimeSlot(id: 42, timeSlot: "08:30 PM"),
        BookingTimeSlot(id: 43, timeSlot: "09:00 PM"),
        BookingTimeSlot(id: 44, timeSlot: "09:30 PM"),
        BookingTimeSlot(id: 45, timeSlot: "10:00 PM"),
        BookingTimeSlot(id: 46, timeSlot: "10:30 PM"),
        BookingTimeSlot(id: 47, timeSlot: "11:00 PM"),
        BookingTimeSlot(id: 48, timeSlot: "11:30 PM")
    ]

    
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
    @IBOutlet weak var serviceTimingLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        selectToday()
        handleServiceTimingCalculation()
    }
    
    private func handleServiceTimingCalculation() {
        serviceTimingLable.text = "Your Service Will approximately takes \(serviceData.count * 30) min"
    }
    
    private func setup() {
        let today = Date().dateAtStartOfDay()
        let startDate = today
        let endDate = today.dateByAddingDays(60)
        dates = startDate.arrayOfdatesTill(endDate)
        DayAndDateCollectionView.reloadData()
    }
    
    @IBAction func paymentMethodButtonDidTapped(_ sender: Any) {
        guard let salonData = salonData else { return }
        guard let userData = AppDataManager.shared.loadUserProfile() else { return }
        
        guard let slots = getSelectedSlots(mySlotSelection) else { return }
        guard let date =  getFormattedDateString() else { return }
        
        let timeStamp = Int((Date().timeIntervalSince1970) * 1000)
        
        
       // guard let expiryDate = combineDateAndTime("",)
        
        let newBooking = BookingModel(
            id: timeStamp,
            saloneImgae: "favouriteImage3",
            salonId: salonData.id,
            userId: userData.userId,
            saloneName: salonData.salonName,
            userName: userData.name,
            address: salonData.address,
            services: serviceData,
            selectedTimeIds: slots,
            bookingDate: date,
            isCancled:false,
            expiryDate:Date()
        )

        BookingManager.shared.createBooking(newBooking) { error in
            DispatchQueue.main.async {
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    func combineDateAndTime(_ dateString: String,_ selectedDate:Date) -> Date? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        // Parse the date string
        guard let date = dateFormatter.date(from: dateString) else {
            print("Error: Invalid date format")
            return nil
        }
        
        let dateComponents = calendar.dateComponents([.minute, .second, .hour], from: date)
        
        // Set time components to midnight
       
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        components.minute = dateComponents.minute
        components.hour = dateComponents.hour
        components.second = dateComponents.second
        
        let combinedDate = calendar.date(from: components)
        
        return combinedDate
    }
    
    private func getFormattedDateString() -> String? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - hh:mm a"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }

    private func selectToday() {
        let firstIndexPath = IndexPath(row: 0, section: 0) // TODO: Change to today
        if DayAndDateCollectionView.validate(firstIndexPath) {
            selectedIndexPaths.append(firstIndexPath)
            DayAndDateCollectionView.reloadItems(at: [firstIndexPath])
            selectCellAt(firstIndexPath)
        }
    }
    
    private func getSelectedSlots(_ indexPath:[IndexPath]) -> [Int]? {
        var ints = [Int]()
        
        for i in indexPath {
            let dd = i.row + 1
            ints.append(dd)
        }
        
        return ints
    }
    
    private func selectCellAt(_ indexPath: IndexPath) {
        DayAndDateCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func getBookedSlotIndexPaths() -> [IndexPath]? {
        if selectedSlotes.count == 0 {
            return nil
        }
        return selectedSlotes.map({  IndexPath(row: $0, section: 0)})
    }
}
extension DateAndTimeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == DayAndDateCollectionView {
            return dates.count
        }
        else {
            return timeSlotData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == DayAndDateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateSelectCollectionViewCell", for: indexPath) as! DateSelectCollectionViewCell
            cell.date = dates[indexPath.row]
            if selectedIndexPaths.contains(indexPath) {
                cell.mainView.backgroundColor = UIColor(named: "EC6E57")
                cell.dayLabel.textColor = .white
                cell.dateLabel.textColor = .white
            }
            else {
                cell.mainView.backgroundColor = UIColor(named: "F2F2F7")
                cell.dayLabel.textColor = .black
                cell.dateLabel.textColor = .black
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionCell", for: indexPath) as! TimeSlotCollectionCell
            let data = timeSlotData[indexPath.row]
            cell.timeSlot.text = data.timeSlot
            
            if let indexPaths = getBookedSlotIndexPaths() {
                cell.mainView.backgroundColor = .red
                cell.timeSlot.textColor = .white
            }
            else if mySlotSelection.contains(indexPath) {
                cell.mainView.backgroundColor = UIColor(named: "EC6E57")
                cell.timeSlot.textColor = .white
            }
            else {
                cell.mainView.backgroundColor = UIColor(named: "F2F2F7")
                cell.timeSlot.textColor = .black
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == DayAndDateCollectionView {
            let width = ( collectionView.frame.width - 75) / 4
            return CGSize(width: width, height: collectionView.frame.height)
        }
        else {
            let width = ( collectionView.frame.width - 30) / 3
            let height = (43 * width) / 107
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == DayAndDateCollectionView {
            if selectedIndexPaths.contains(indexPath) {
                selectedIndexPaths.removeAll()
            }
            else {
                selectedIndexPaths.removeAll()
                selectedIndexPaths.append(indexPath)
            }
            DayAndDateCollectionView.reloadData()
            selectCellAt(indexPath)
            
            mySlotSelection.removeAll()
            TimeSlotCollectionView.reloadData()
        }else{
            handleSlotSelection(indexPath)
        }
    }
    
    private func handleSlotSelection(_ indexPath:IndexPath) {
        let mySlotLength = serviceData.count
        
        if mySlotSelection.contains(indexPath) {
            if let index = mySlotSelection.firstIndex(where: { $0 == indexPath }) {
                mySlotSelection.remove(at: index)
            }
            TimeSlotCollectionView.reloadData()
            return
        }

        if mySlotSelection.count >= mySlotLength {
            showToast("Please unselect a slot to select.")
            return
        }
        
        let slotId = timeSlotData[indexPath.row].id
        if selectedSlotes.contains(slotId) {
            showToast("This slot is already booked. Please select another.")
            return
        }
        mySlotSelection.append(indexPath)
        TimeSlotCollectionView.reloadData()
    }
    
    private func showToast(_ message:String) {
        DispatchQueue.main.async {
            let toast = Toast.default(
                image: UIImage(named: "mark")!,
                title: message
            )
            toast.show()
        }
    }
}


struct BookingModel:Codable {
    let id:Int
    let saloneImgae:String?
    let salonId:String
    let userId:String
    let saloneName:String?
    let userName:String?
    let address:String?
    let services:[SalonServices]?
    let selectedTimeIds:[Int]?
    let bookingDate:String?
    let isCancled:Bool?
    let expiryDate:Date?
}
