import Foundation
import Firebase

class ReviewManager {
    static let shared = ReviewManager()
    private let db = Firestore.firestore()
    private let reviewCollection = "reviews"
    
    // MARK: - CRUD Operations
    
    // Create a new review
    func createReview(_ review: SalonReview, completion: @escaping (Error?) -> Void) {
        var data = [String: Any]()
        data["id"] = review.id
        data["image"] = review.image
        data["saloneName"] = review.saloneName
        data["serviceNames"] = review.serviceNames
        data["address"] = review.address
        data["timingLabel"] = review.timingLabel
        data["overAllRating"] = review.overAllRating
        
        data["reviewCountLabel"] = review.reviewCountLabel
        data["serviceRating"] = review.serviceRating
        data["hygieneRating"] = review.hygieneRating
        data["staffRating"] = review.staffRating
        data["moneyRating"] = review.moneyRating
        data["experienceRating"] = review.experienceRating
        
        if let userCommentData = review.userCommentData {
            data["userCommentData"] = userCommentData.map { userData in
                return [
                    "userId": userData.userId,
                    "image": userData.image,
                    "name": userData.name,
                    "address": userData.address,
                    "reviewCountLabel": userData.reviewCountLabel,
                    "serviceRating": userData.serviceRating,
                    "hygieneRating": userData.hygieneRating,
                    "staffRating": userData.staffRating,
                    "moneyRating": userData.moneyRating,
                    "experienceRating": userData.experienceRating,
                    "comment": userData.comment
                ]
            }
        }
        
        db.collection(reviewCollection).addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // Read reviews for a specific user
    func getReviews(forUserId userId: String,
                    completion: @escaping ([SalonReview]?, Error?) -> Void) {
        
        db.collection(reviewCollection)
            .whereField("id", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    var reviews = [SalonReview]()
                    for document in snapshot!.documents {
                        if let review = self.review(from: document) {
                            reviews.append(review)
                        }
                    }
                    completion(reviews, nil)
                }
            }
    }
    
    // Helper method to parse Firestore document into Salon struct
    private func review(from document: QueryDocumentSnapshot) -> SalonReview? {
        let data = document.data()
        
        guard let id = data["id"] as? String else {
            return nil
        }
        
        var userCommentData: [UserRatingData]? = nil
        if let userData = data["userCommentData"] as? [[String: Any]] {
            userCommentData = userData.map { userData in
                return UserRatingData(
                    userId: userData["userId"] as? String ?? "",
                    image: userData["image"] as? String,
                    name: userData["name"] as? String,
                    address: userData["address"] as? String,
                    reviewCountLabel: userData["reviewCountLabel"] as? String,
                    serviceRating: userData["serviceRating"] as? Int,
                    hygieneRating: userData["hygieneRating"] as? Int,
                    staffRating: userData["staffRating"] as? Int,
                    moneyRating: userData["moneyRating"] as? Int,
                    experienceRating: userData["experienceRating"] as? Int,
                    comment: userData["comment"] as? String
                )
            }
        }
        
        return SalonReview(
            id: id,
            image: data["image"] as? String,
            saloneName: data["saloneName"] as? String,
            serviceNames: data["serviceNames"] as? String,
            address: data["address"] as? String,
            timingLabel: data["timingLabel"] as? String,
            overAllRating: data["overAllRating"] as? String,
            reviewCountLabel: data["reviewCountLabel"] as? String,
            serviceRating: data["serviceRating"] as? Int,
            hygieneRating: data["hygieneRating"] as? Int,
            staffRating: data["staffRating"] as? Int,
            moneyRating: data["moneyRating"] as? Int,
            experienceRating: data["experienceRating"] as? Int,
            userCommentData: userCommentData
        )
    }
    
    // Update a review
    func updateReview(_ review: SalonReview, completion: @escaping (Error?) -> Void) {
        let reviewDocument = db.collection(reviewCollection).document(review.id)
        
        var data = [String: Any]()
        data["id"] = review.id
        data["image"] = review.image
        data["saloneName"] = review.saloneName
        data["serviceNames"] = review.serviceNames
        data["address"] = review.address
        data["timingLabel"] = review.timingLabel
        data["overAllRating"] = review.overAllRating
        
        data["reviewCountLabel"] = review.reviewCountLabel
        data["serviceRating"] = review.serviceRating
        data["hygieneRating"] = review.hygieneRating
        data["staffRating"] = review.staffRating
        data["moneyRating"] = review.moneyRating
        data["experienceRating"] = review.experienceRating
        
        if let userCommentData = review.userCommentData {
            data["userCommentData"] = userCommentData.map { userData in
                return [
                    "userId": userData.userId,
                    "image": userData.image,
                    "name": userData.name,
                    "address": userData.address,
                    "reviewCountLabel": userData.reviewCountLabel,
                    "serviceRating": userData.serviceRating,
                    "hygieneRating": userData.hygieneRating,
                    "staffRating": userData.staffRating,
                    "moneyRating": userData.moneyRating,
                    "experienceRating": userData.experienceRating,
                    "comment": userData.comment
                ]
            }
        }
        
        reviewDocument.setData(data, merge: true) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // Delete a review
    func deleteReview(_ reviewId: String, completion: @escaping (Error?) -> Void) {
        db.collection(reviewCollection).document(reviewId).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}


struct SalonReview {
    let id:String
    var image: String?
    var saloneName: String?
    var serviceNames: String?
    var address: String?
    var timingLabel: String?
    var overAllRating:String?
    
    var reviewCountLabel: String?
    var serviceRating: Int?
    var hygieneRating: Int?
    var staffRating: Int?
    var moneyRating: Int?
    var experienceRating: Int?
    
    var userCommentData:[UserRatingData]?
}

struct UserRatingData {
    let userId:String
    var image: String?
    var name: String?
    var address: String?
    
    var reviewCountLabel: String?
    var serviceRating: Int?
    var hygieneRating: Int?
    var staffRating: Int?
    var moneyRating: Int?
    var experienceRating: Int?
    
    var comment:String?
}
