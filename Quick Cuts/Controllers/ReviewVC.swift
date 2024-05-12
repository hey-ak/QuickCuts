import UIKit
import FirebaseFirestoreInternal
import SDWebImage
import FirebaseAuth
import Cosmos

class ReviewVC: UIViewController {
    
    public var saloneId:String?
    private var db = Firestore.firestore()
    private var previousComments:[UserRatingData]?
    private var saloneData:SalonModel?
    
    
    @IBOutlet weak var saloneImage: UIImageView!
    @IBOutlet weak var saloneName: UILabel!
    @IBOutlet weak var saloneServiceNames: UILabel!
    @IBOutlet weak var saloneAddress: UILabel!
    @IBOutlet weak var timeingLable: UILabel!
    @IBOutlet weak var reviewCountLable: UILabel!
    
    @IBOutlet weak var serviceRating: CosmosView!
    @IBOutlet weak var hygeneRating: CosmosView!
    @IBOutlet weak var staffRating: CosmosView!
    @IBOutlet weak var moneyRating: CosmosView!
    @IBOutlet weak var experienceRating: CosmosView!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let saloneId = saloneId {
            getSaloneData(saloneId)
        }
    }
    
    @IBAction func saveDidTapped(_ sender: Any) {
        saveReviewData()
    }
    
    private func saveReviewData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let salonId = saloneId else { return }
        guard let comment = reviewTextView.text else { return }
        guard let saloneData = self.saloneData else { return }
        guard let userData = AppDataManager.shared.loadUserProfile() else { return }
        
        var serviceRating: Double = 0.0
        var hygieneRating: Double = 0.0
        var staffRating: Double = 0.0
        var moneyRating: Double = 0.0
        var experienceRating: Double = 0.0

        serviceRating = self.serviceRating.rating
        hygieneRating = self.hygeneRating.rating
        staffRating = self.staffRating.rating
        moneyRating = self.moneyRating.rating
        experienceRating = self.experienceRating.rating
        
        var commentsData = [UserRatingData]()
        
        if let previousComments = previousComments {
            commentsData = previousComments
        }
        
        let userCommentedData = UserRatingData(userId:userId,
                                               image: userData.profile,
                                               name: userData.name,
                                               address: "",
                                               reviewCountLabel: "",
                                               serviceRating: Int(serviceRating),
                                               hygieneRating: Int(hygieneRating),
                                               staffRating: Int(staffRating),
                                               moneyRating: Int(moneyRating),
                                               experienceRating: Int(experienceRating),
                                               comment: comment)
        
        commentsData.append(userCommentedData)
        
        let newReview = SalonReview(id: salonId,
                                    image: saloneData.image,
                                    saloneName: saloneData.salonName,
                                    serviceNames: saloneData.services?.first?.serviceName ?? "",
                                    address: saloneData.address,
                                    timingLabel: "",
                                    overAllRating: "0",
                                    reviewCountLabel: "0",
                                    serviceRating: 5,
                                    hygieneRating: 4,
                                    staffRating: 5,
                                    moneyRating: 4,
                                    experienceRating: 5,
                                    userCommentData: commentsData)

        ReviewManager.shared.createReview(newReview) {[weak self] error in
            DispatchQueue.main.async {
                self?.getSalonReview(salonId)
            }
        }
    }
    
    private func getSaloneData(_ saloneId:String) {
        FirebaseManager().getSalon(salonId: saloneId) {[weak self] (salon, error) in
            guard error == nil,let salone = salon else { return }
            DispatchQueue.main.async {
                self?.populateSaloneData(salone)
            }
        }
    }
    
    private func populateSaloneData(_ salone: SalonModel) {
        self.saloneData = salone
        if let url = salone.image,
           let profileUrl = URL(string: url) {
            saloneImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            saloneImage.sd_setImage(with: profileUrl,
                                    placeholderImage: UIImage(named: "profilePic"))
        }
        else {
            saloneImage.image = UIImage(named: "profilePic")
        }
        saloneName.text = salone.salonName
        saloneAddress.text = salone.address
        saloneServiceNames.text = salone.services?.first?.serviceName
        reviewCountLable.text = "\(salone.reviews ?? 0) Reviews \(salone.rating ?? 0.0) Stars"
    }
    
    private func getSalonReview(_ salonId:String) {
        ReviewManager.shared.getReviews(forUserId: salonId) { [weak self] reviews, error in
            if let error = error { print( error.localizedDescription ) }
            else if let reviews = reviews {
                if reviews.count > 0 {
                    self?.processRating(reviews)
                }
            }
        }
    }
    
    private func processRating(_ reviews: [SalonReview]) {
        var totleStarsCount = 0
        var allUserTotleStars:Int = 0
        var commentsTotle = 0
        
        for review in reviews {
            guard let comments = review.userCommentData else { continue }
            commentsTotle = commentsTotle + comments.count
            totleStarsCount = totleStarsCount + (comments.count * 5 * 5)
            
            for review1 in comments {
                if let serviceRating = review1.serviceRating,
                   let hygieneRating = review1.hygieneRating,
                   let staffRating = review1.staffRating,
                   let moneyRating = review1.moneyRating,
                   let experienceRating = review1.experienceRating {
                    
                    let totleStars = serviceRating + hygieneRating + staffRating + moneyRating + experienceRating
                    allUserTotleStars = allUserTotleStars + totleStars
                }
            }
        }
        
        let averageStar = Int(allUserTotleStars / (totleStarsCount / 5))
        updateReviewData(averageStar, commentCount: commentsTotle)
    }
    
    private func updateReviewData(_ averageRating:Int,commentCount:Int) {
        guard let saloneId = self.saloneId else { return }
        
        FirebaseManager().getSalon(salonId: saloneId) {[weak self] (salon, error) in
            guard error == nil,var salone = salon else { return }
            
            var userProfile = salone
            userProfile.reviews = commentCount
            userProfile.rating = Double(averageRating)
            
            self?.updateUserProfile(for: saloneId, with: userProfile) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.showToast("Review submited sucessfully.")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showToast("Review submission Failed.")
                    }
                }
            }
        }
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
    
    public func updateUserProfile(for userId: String, with updatedData: SalonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userProfileData = try Firestore.Encoder().encode(updatedData)
            let userProfileRef = db.collection("salons").document(userId)
            
            userProfileRef.setData(userProfileData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
