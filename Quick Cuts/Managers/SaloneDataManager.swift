import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class FirebaseManager {
    
    let db = Firestore.firestore()
    
    init() {} // Singleton
    
    // MARK: - SalonModel
    
    func addSalon(salon: SalonModel, image: UIImage?, completion: @escaping (Error?) -> Void) {
            let imageRef = Storage.storage().reference().child("salon_images/\(UUID().uuidString).jpg")
            
            guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                completion(NSError(domain: "YourAppDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    completion(error)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(error)
                        } else if let downloadURL = url {
                            var salonWithImageUrl = salon
                            salonWithImageUrl.image = downloadURL.absoluteString
                            
                            do {
                                _ = try self.db.collection("salons").addDocument(from: salonWithImageUrl, completion: completion)
                            } catch {
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
        
        func updateSalon(salonId: String, salon: SalonModel, image: UIImage?, completion: @escaping (Error?) -> Void) {
            let imageRef = Storage.storage().reference().child("salon_images/\(UUID().uuidString).jpg")
            
            guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
                completion(NSError(domain: "YourAppDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    completion(error)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(error)
                        } else if let downloadURL = url {
                            var salonWithImageUrl = salon
                            salonWithImageUrl.image = downloadURL.absoluteString
                            
                            do {
                                try self.db.collection("salons").document(salonId).setData(from: salonWithImageUrl, merge: true, completion: completion)
                            } catch {
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
    
    func deleteSalon(salonId: String, completion: @escaping (Error?) -> Void) {
        db.collection("salons").document(salonId).delete(completion: completion)
    }
    
    func getSalon(salonId: String, completion: @escaping (SalonModel?, Error?) -> Void) {
        db.collection("salons").document(salonId).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let salon = try document.data(as: SalonModel.self)
                    completion(salon, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - SalonServices
    
    func addService(salonId: String, service: SalonServices, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("salons").document(salonId).collection("services").addDocument(from: service, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func updateService(salonId: String, serviceId: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("salons").document(salonId).collection("services").document(serviceId).updateData(data, completion: completion)
    }
    
    func deleteService(salonId: String, serviceId: String, completion: @escaping (Error?) -> Void) {
        db.collection("salons").document(salonId).collection("services").document(serviceId).delete(completion: completion)
    }
    
    func getServicesForSalon(salonId: String, completion: @escaping ([SalonServices]?, Error?) -> Void) {
        db.collection("salons").document(salonId).collection("services").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                let services = querySnapshot?.documents.compactMap { document -> SalonServices? in
                    try? document.data(as: SalonServices.self)
                }
                completion(services, nil)
            }
        }
    }
    
    // MARK: - OpenDays
    
    func addOpenDay(salonId: String, openDay: OpenDays, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("salons").document(salonId).collection("openDays").addDocument(from: openDay, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func updateOpenDay(salonId: String, openDayId: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("salons").document(salonId).collection("openDays").document(openDayId).updateData(data, completion: completion)
    }
    
    func deleteOpenDay(salonId: String, openDayId: String, completion: @escaping (Error?) -> Void) {
        db.collection("salons").document(salonId).collection("openDays").document(openDayId).delete(completion: completion)
    }
    
    func getOpenDaysForSalon(salonId: String, completion: @escaping ([OpenDays]?, Error?) -> Void) {
        db.collection("salons").document(salonId).collection("openDays").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                let openDays = querySnapshot?.documents.compactMap { document -> OpenDays? in
                    try? document.data(as: OpenDays.self)
                }
                completion(openDays, nil)
            }
        }
    }
}
