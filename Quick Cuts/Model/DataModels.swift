

import Foundation

struct User {
    let userID: UUID
    let name: String
    let email: String
    let phoneNumber: String
    let gender: Gender
    let photos: [String]
    let favoriteSalons: [Salon]
    let visitedSalons: [String]
}


enum Gender {
    case male, female, other
}


struct Payment {
    let paymentID: UUID
    let amount: Double
    let date: Date
    let method: PaymentMethod
}

enum PaymentMethod {
    case creditCard
    case debitCard
    case cash
    case upi
}

struct Service {
    let serviceID: UUID
    let serviceName: String
    let price: Int
}



struct BookingSlot {
    let bookingSlotID: UUID
    let customer: User
    let salon: Salon
    let date: Date
    let timeSlot: String
    let serviceType: Service
    let duration: Int
    var isAvailable: Bool = true
    var canVisit: Bool = true
    var payment: Payment?
}


struct Salon {
    let salonID: UUID
    let email: String
    let name: String
    let gstNumber: String
    let rating: Double
    let photoURLs: [String]
    let address: String
    let location: [String]
    let isVerified: Bool
    let services: [Service]
}

struct Review {
    var user: User
    var salon: Salon
    var rating: Double
    var comment: String
}

struct currentBookingDM {
    let salonName: String
    let salonAddress: String
    let serviceID: String
    let salonImage: String
}


struct HomeCard{
    let salonName:String
    let salonAddress:String
    let reviewCount:Int
    let salonImage:String
}

struct HomeServices{
    let serviceImage:String
    let serviceName:String
}

struct CompletedServicesDM {
    let salonName: String
    let salonAddress: String
    let serviceID: String
    let salonImage: String
}

struct CancelledServicesDM {
    let salonName: String
    let salonAddress: String
    let serviceID: String
    let salonImage: String
}

struct serviceDM {
    let serviceName: String
    let servicePrice: Int
}

struct BookingTimeSlot {
    let timeSlot: String
}

struct DayAndDateDM {
    let dayLabel: String
    let dateLabel: String
}

struct ProfileDM {
    let profileLabel: String
    let profileIcon: String
}


struct FavouriteCard{
    let salonName:String
    let salonAddress:String
    let reviewCount:Int
    let salonImage:String
}


struct Notification{
    let name:String
    let message:String
    let time:String
}

