import Foundation
import Firebase

class BookingManager {
    static let shared = BookingManager()
    private let db = Firestore.firestore()
    private let bookingCollection = "bookings"
    
    // MARK: - CRUD Operations
    
    // Create a new booking
    func createBooking(_ booking: BookingModel, completion: @escaping (Error?) -> Void) {
        var data = [String: Any]()
        data["id"] = booking.id
        data["saloneImgae"] = booking.saloneImgae
        data["salonId"] = booking.salonId
        
        data["expiryDate"] = booking.expiryDate
        data["isCancled"] = booking.isCancled
        
        
        data["userId"] = booking.userId
        data["saloneName"] = booking.saloneName
        data["userName"] = booking.userName
        data["address"] = booking.address
        data["services"] = booking.services?.map { service in
            return [
                "id": service.id,
                "serviceImage": service.serviceImage,
                "serviceName": service.serviceName,
                "servicePrice": service.servicePrice ?? 0.0
            ]
        }
        data["selectedTimeIds"] = booking.selectedTimeIds
        data["bookingDate"] = booking.bookingDate
        
        db.collection(bookingCollection).addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func getBookings(forUserId userId: String, completion: @escaping ([BookingModel]?, Error?) -> Void) {
        db.collection(bookingCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    var bookings = [BookingModel]()
                    for document in snapshot!.documents {
                        if let booking = self.booking(from: document) {
                            bookings.append(booking)
                        }
                    }
                    completion(bookings, nil)
                }
            }
    }
    
    // Read bookings
    func getBookings(completion: @escaping ([BookingModel]?, Error?) -> Void) {
        db.collection(bookingCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                var bookings = [BookingModel]()
                for document in snapshot!.documents {
                    if let booking = self.booking(from: document) {
                        bookings.append(booking)
                    }
                }
                completion(bookings, nil)
            }
        }
    }
    
    // Helper method to parse Firestore document into BookingModel
    private func booking(from document: QueryDocumentSnapshot) -> BookingModel? {
        let data = document.data()
        guard
            let id = data["id"] as? Int,
            let salonId = data["salonId"] as? String,
            let userId = data["userId"] as? String
        else {
            return nil
        }
        
        let expiryDate = data["expiryDate"] as? Date 
        let isCancled = data["isCancled"] as? Bool
        
        let saloneImgae = data["saloneImgae"] as? String
        let saloneName = data["saloneName"] as? String
        let userName = data["userName"] as? String
        let address = data["address"] as? String
        let services = (data["services"] as? [[String: Any]] ?? []).compactMap { serviceData in
            return SalonServices(
                id: serviceData["id"] as? Int ?? 0,
                serviceImage: serviceData["serviceImage"] as? String,
                serviceName: serviceData["serviceName"] as? String,
                servicePrice: serviceData["servicePrice"] as? Double
            )
        }
        let selectedTimeIds = data["selectedTimeIds"] as? [Int]
        let bookingDate = data["bookingDate"] as? String
        
        return BookingModel(
            id: id,
            saloneImgae: saloneImgae,
            salonId: salonId,
            userId: userId,
            saloneName: saloneName,
            userName: userName,
            address: address,
            services: services,
            selectedTimeIds: selectedTimeIds,
            bookingDate: bookingDate,
            isCancled:isCancled,
            expiryDate:expiryDate
        )
    }
    
    // Update a booking
    func updateBooking(_ booking: BookingModel, completion: @escaping (Error?) -> Void) {
        let bookingDocument = db.collection(bookingCollection).document("\(booking.id)")
        
        var data = [String: Any]()
        data["id"] = booking.id
        
        
        data["expiryDate"] = booking.expiryDate
        data["isCancled"] = booking.isCancled
        
        
        data["saloneImgae"] = booking.saloneImgae
        data["salonId"] = booking.salonId
        data["userId"] = booking.userId
        data["saloneName"] = booking.saloneName
        data["userName"] = booking.userName
        data["address"] = booking.address
        data["services"] = booking.services?.map { service in
            return [
                "id": service.id,
                "serviceImage": service.serviceImage,
                "serviceName": service.serviceName,
                "servicePrice": service.servicePrice ?? 0.0
            ]
        }
        data["selectedTimeIds"] = booking.selectedTimeIds
        data["bookingDate"] = booking.bookingDate
        
        bookingDocument.setData(data, merge: true) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // Delete a booking
    func deleteBooking(_ bookingId: Int, completion: @escaping (Error?) -> Void) {
        db.collection(bookingCollection).document("\(bookingId)").delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
