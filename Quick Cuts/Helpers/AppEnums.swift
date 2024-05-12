import Foundation

enum UserDefaultKeys:String {
    case userID = "loggedUserId"
}

enum UserType:String {
    case user = "0"
    case admin = "1"
}

enum UserProfileError: Error {
    case documentNotFound
    case decodingError
    case firestoreError(String)
    case downloadURLNotFound
    case imageDataConversionFailed
    case unknownError
}

enum ProfileImageError: Error {
    case documentNotFound
    case decodingError
    case firestoreError(String)
    case downloadURLNotFound
    case imageDataConversionFailed
    case unknownError
}

enum LogoutError: Error {
    case signOutFailed(reason: String)
}
