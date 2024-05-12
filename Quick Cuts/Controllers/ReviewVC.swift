import UIKit
import FirebaseFirestoreInternal
import SDWebImage
import FirebaseAuth
import Cosmos

class ReviewVC: UIViewController {
    
    public var saloneId:String?
    private var db = Firestore.firestore()
    private var previousComments:[UserRatingData]?
    
    
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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        getSalonReview(userId)
    }
    
    private func saveReviewData() {
        guard let comment = reviewTextView.text else { return }
        
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
        reviewCountLable.text = "\(salone.reviews ?? 0) Reviews"
    }
    
    private func getSalonReview(_ salonId:String) {
        ReviewManager.shared.getReviews(forUserId: salonId) { [weak self] reviews, error in
            if let error = error { print( error.localizedDescription ) }
            else if let reviews = reviews {
                if reviews.count > 0,let firstReview = reviews.first {
                    self?.processRating(firstReview)
                }
            }
        }
    }
    
    private func processRating(_ reviews: SalonReview) {
        guard let comments = reviews.userCommentData else { return }
        self.previousComments = comments
        let totleStarsCount = comments.count * 5 * 5
        
        var allUserTotleStars:Int = 0
        
        for review in comments {
            if let serviceRating = review.serviceRating,
               let hygieneRating = review.hygieneRating,
               let staffRating = review.staffRating,
               let moneyRating = review.moneyRating,
               let experienceRating = review.experienceRating {
                
                let totleStars = serviceRating + hygieneRating + staffRating + moneyRating + experienceRating
                allUserTotleStars = allUserTotleStars + totleStars
            }
        }
        let averageStar = Int(allUserTotleStars / (totleStarsCount / 5))
        updateReviewData(averageStar, commentCount: comments.count)
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
                    DispatchQueue.main.async {  }
                case .failure(let error):
                    DispatchQueue.main.async {  }
                }
            }
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
