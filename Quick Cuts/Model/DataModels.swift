//
//  DataModels.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 26/04/24.
//

import Foundation

struct User {
    let userID: UUID
    let name: String
    let email: String
    let phoneNumber: String
    let gender: Gender
    let photos: [String]
    let favoriteSalons: [Salon]
    let visitedSalons: [VisitedSalon]
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
    let location: Location Coordinate
    let isVerified: Bool
    let services: [Service]
}

struct Service {
    let serviceID: UUID
    let serviceName: String
    let price: Int
}