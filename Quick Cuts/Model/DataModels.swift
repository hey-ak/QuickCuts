

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
    let section: Int
    let profileData: [ProfileData]
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

struct ProfileData {
    let row: Int
    let userProfileDetails: UserProfileDetails?
    let profileOption: ProfileOptions
}

struct UserProfileDetails {
    let phoneNumber: String?
    let userImage: String?
    let userName: String?
}

enum ProfileOptions: String {
    case yourProfile = "Your Profile"
    case paymentMethod = "Payment Method"
    case favourites = "Favourites"
    case transaction = "Transaction"
    case setting = "Setting"
    case helpCenter = "Help Center"
    case privacyPolicy = "Privacy Policy"
    case logOut = "LogOut"
}

let userProfileDetails = UserProfileDetails(phoneNumber: "+91 7986305141",
                                            userImage: "profilePic",
                                            userName: "Neeraj Sharma")

let profileDM = [ProfileDM.init(section: 0,
                                profileData: [ProfileData(row: 0,
                                                          userProfileDetails: userProfileDetails,
                                                          profileOption: .yourProfile)]),
                 ProfileDM.init(section: 1,
                                profileData: [ProfileData(row: 0,
                                                          userProfileDetails: nil,
                                                          profileOption: .yourProfile),
                                              ProfileData(row: 1,
                                                          userProfileDetails: nil,
                                                          profileOption: .paymentMethod),
                                              ProfileData(row: 2,
                                                          userProfileDetails: nil,
                                                          profileOption: .favourites),
                                              ProfileData(row: 3,
                                                          userProfileDetails: nil,
                                                          profileOption: .transaction)]),
                 ProfileDM.init(section: 2,
                                profileData: [ProfileData(row: 0,
                                                          userProfileDetails: nil,
                                                          profileOption: .setting),
                                              ProfileData(row: 1,
                                                          userProfileDetails: nil,
                                                          profileOption: .helpCenter),
                                              ProfileData(row: 2,
                                                          userProfileDetails: nil,
                                                          profileOption: .privacyPolicy),
                                              ProfileData(row: 3,
                                                          userProfileDetails: nil,
                                                          profileOption: .logOut)])]
