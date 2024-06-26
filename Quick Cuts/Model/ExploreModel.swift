import Foundation

struct SalonModel {
    let id:Int
    let image:String?
    let salonName:String
    let subTitle:String?
    let about:String?
    let address:String?
    let rating:Double?
    let reviews:Int?
    let latitude:Double?
    let longitude:Double?
    let openDays:[OpenDays]?
    let openingTime:Date
    let closingTime:Date
    let services:[SalonServices]?
}

struct SalonServices {
    let id:Int
    let serviceImage:String?
    let serviceName:String?
    let servicePrice:Double?
}

struct OpenDays {
    let id:Int
    let dayNumber:Int
}

// Dummy data for SalonServices
let service1 = SalonServices(id: 1, serviceImage: "image1.jpg", serviceName: "Haircut", servicePrice: 20.0)
let service2 = SalonServices(id: 2, serviceImage: "image2.jpg", serviceName: "Manicure", servicePrice: 15.0)
let service3 = SalonServices(id: 3, serviceImage: "image3.jpg", serviceName: "Massage", servicePrice: 30.0)

// Dummy data for OpenDays
let monday = OpenDays(id: 1, dayNumber: 1)
let tuesday = OpenDays(id: 2, dayNumber: 2)
let wednesday = OpenDays(id: 3, dayNumber: 3)
let thursday = OpenDays(id: 4, dayNumber: 4)
let friday = OpenDays(id: 5, dayNumber: 5)

// Dummy data for SalonModel
let salon = SalonModel(id: 1,
                       image: "salonImage1",
                       salonName: "Glamorous Salon",
                       subTitle: "Glamour Unveiled: Inside the World of the Glamorous Salon",
                       about: "We offer a wide range of beauty services.",
                       address: "123 Main St, Cityville, England",
                       rating: 4.5,
                       reviews: 50,
                       latitude: 29.153460,
                       longitude: 75.712807,
                       openDays: [monday, tuesday, wednesday, thursday, friday],
                       openingTime: Date(),
                       closingTime: Date(),
                       services: [service1, service2, service3])

// Dummy data for SalonServices
let service4 = SalonServices(id: 4, serviceImage: "image4.jpg", serviceName: "Pedicure", servicePrice: 25.0)
let service5 = SalonServices(id: 5, serviceImage: "image5.jpg", serviceName: "Facial", servicePrice: 35.0)
let service6 = SalonServices(id: 6, serviceImage: "image6.jpg", serviceName: "Waxing", servicePrice: 18.0)

// Dummy data for OpenDays
let saturday = OpenDays(id: 6, dayNumber: 6)
let sunday = OpenDays(id: 7, dayNumber: 7)

// Dummy data for SalonModel
let salon2 = SalonModel(id: 2,
                        image: "salonImage3",
                        salonName: "Chic Hair Studio",
                        subTitle: "Style Refined: Journey into the Chic Hair Studio",
                        about: "We specialize in trendy hairstyles.",
                        address: "456 Elm St, Townsville, USA",
                        rating: 4.2,
                        reviews: 35,
                        latitude: 30.559584,
                        longitude: 76.698196,
                        openDays: [monday, tuesday, wednesday, thursday, friday, saturday],
                        openingTime: Date(),
                        closingTime: Date(),
                        services: [service1, service2, service3])

// Dummy data for SalonModel
let salon3 = SalonModel(id: 3,
                        image: "salonImage5",
                        salonName: "Beauty Bliss Spa",
                        subTitle: "Indulge & Unwind: Discovering Beauty Bliss Spa",
                        about: "Relax and rejuvenate with our spa treatments.",
                        address: "789 Oak St, Villagetown, Australia",
                        rating: 4.7,
                        reviews: 60,
                        latitude: 25.091800,
                        longitude: 86.060470,
                        openDays: [monday, wednesday, friday, saturday, sunday],
                        openingTime: Date(),
                        closingTime: Date(),
                        services: [service1, service2, service3])

// Dummy data for SalonModel
let salon4 = SalonModel(id: 4,
                        image: "salonImage6",
                        salonName: "Nail Artistry",
                        subTitle: "Nails Transformed: Exploring the World of Nail Artistry",
                        about: "Get creative with our nail designs.",
                        address: "101 Pine St, Riverside, Pakistan",
                        rating: 4.0,
                        reviews: 25,
                        latitude: 29.1562688,
                        longitude: 75.7292303,
                        openDays: [tuesday, thursday, friday, saturday, sunday],
                        openingTime: Date(),
                        closingTime: Date(),
                        services: [service1, service2, service3])

// Dummy data for SalonModel
let salon5 = SalonModel(id: 5,
                        image: "salonImage7",
                        salonName: "Gentlemen's Grooming",
                        subTitle: "Suave Sophistication: Inside Gentlemen's Grooming",
                        about: "We cater to the modern gentleman.",
                        address: "222 Maple St, Lakeside, Antatica",
                        rating: 4.8,
                        reviews: 45,
                        latitude: 30.32715,
                        longitude: 76.40266,
                        openDays: [monday, wednesday, thursday, friday],
                        openingTime: Date(),
                        closingTime: Date(),
                        services: [service1, service2, service3])

// Dummy data for SalonModel
let salon6 = SalonModel(id: 6,
                        image: "salonImage3",
                        salonName: "Crazy's Grooming",
                        subTitle: "Unleash the Bold: Journey into Crazy's Grooming",
                        about: "We cater to the modern gentleman.",
                        address: "222 Maple St, Lakeside, Gonda Zilla",
                        rating: 4.8,
                        reviews: 45,
                        latitude: 30.655726,
                        longitude: 76.820065,
                        openDays: [monday, wednesday, thursday, friday],
                        openingTime: Date(),
                        closingTime: Date(),
                        services: [service1, service2, service3])

var allSalonData:[SalonModel] = [salon,salon2,salon3,salon4,salon5,salon6]
