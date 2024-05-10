import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class AppDataManager {
    
    static let shared = AppDataManager()
    private var db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    
    public func saveLoggedUserID(_ userId:String) {
        userDefaults.set(userId, forKey: UserDefaultKeys.userID.rawValue)
    }
    
    public func getLoggedUserId() -> String? {
        return userDefaults.value(forKey: UserDefaultKeys.userID.rawValue) as? String
    }
    
    public func saveUserProfile(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
    
    public func loadUserProfile() -> UserProfile? {
        if let savedProfile = UserDefaults.standard.object(forKey: "userProfile") as? Data {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(UserProfile.self, from: savedProfile) {
                return loadedProfile
            }
        }
        return nil
    }

    public func logoutUser() -> Result<Void, LogoutError> {
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: UserDefaultKeys.userID.rawValue)
            return .success(())
        } catch let signOutError as NSError {
            let errorDescription = "Error signing out: \(signOutError.localizedDescription)"
            return .failure(.signOutFailed(reason: errorDescription))
        }
    }
    
    public func createUserProfile(_ userId: String, _ userData: UserProfile) {
        do {
            let userProfileRef = db.collection("userProfile").document(userId)
            try userProfileRef.setData(from: userData)
        } catch {
            showToast(error.localizedDescription)
        }
    }
    
    public func fetchUserProfile(for userId: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let userProfileRef = db.collection("userProfile").document(userId)
        
        userProfileRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    if let document = document, document.exists {
                        let userProfile = try document.data(as: UserProfile.self)
                        completion(.success(userProfile))
                    } else {
                        // User profile document does not exist
                        completion(.failure(UserProfileError.documentNotFound))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func updateUserProfile(for userId: String, with updatedData: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userProfileData = try Firestore.Encoder().encode(updatedData)
            let userProfileRef = db.collection("userProfile").document(userId)
            
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
    
    public func uploadProfileImage(_ image: UIImage, for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(ProfileImageError.imageDataConversionFailed))
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error ?? ProfileImageError.unknownError))
                return
            }

            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    let userProfileRef = self.db.collection("userProfile").document(userId)
                    userProfileRef.setData(["profileImageUrl": downloadURL.absoluteString], merge: true) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(downloadURL.absoluteString))
                        }
                    }
                } else {
                    completion(.failure(error ?? ProfileImageError.unknownError))
                }
            }
        }
    }

    public func userProfileImageURL(for userId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let profileImageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        profileImageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let downloadURL = url {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(UserProfileError.downloadURLNotFound))
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
}

struct UserProfile:Codable {
    var userId:String
    var name:String?
    var profile:String?
    var userType:String?
    var phoneNumber:String?
    
    mutating func convertDocumentToStruct(doc: DocumentSnapshot) {
        self.userId = doc.get("userId") as? String ?? "nil"
        self.name = doc.get("name") as? String
        self.profile = doc.get("profile") as? String
        self.userType = doc.get("userType") as? String
        self.phoneNumber = doc.get("phoneNumber") as? String
    }
}
