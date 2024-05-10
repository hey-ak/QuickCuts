import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import DropDown
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.getCurrentLocation()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        DropDown.startListeningToKeyboard()
        setApperance()
        
        return true
    }
    
    private func setApperance() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}







//func testAddSalonWithImage() {
//        let salon = SalonModel(id: 1, salonName: "Test Salon", subTitle: "Test Subtitle", about: "Test About", address: "Test Address", rating: 4.5, reviews: 10, latitude: 123.456, longitude: 78.901, openDays: nil, openingTime: Date(), closingTime: Date(), services: nil)
//        
//        // Create a sample image for testing
//        let testImage = UIImage(named: "sample_image") // Replace "sample_image" with the name of your test image asset
//    var firebaseManager = FirebaseManager()
//        firebaseManager.addSalon(salon: salon, image: testImage) { error in
//            if let error = error {
//                print("Error adding salon with image: \(error.localizedDescription)")
//            } else {
//                print("Salon added successfully with image!")
//            }
//        }
//    }
//
//    func testUpdateSalon() {
//        // Replace 'salonId' with the actual ID of the salon you want to update
//        let salonId = "your_salon_id_here"
//        
//        let updatedSalon = SalonModel(id: 1, salonName: "Updated Salon Name", subTitle: "Updated Subtitle", about: "Updated About", address: "Updated Address", rating: 4.7, reviews: 15, latitude: 123.456, longitude: 78.901, openDays: nil, openingTime: Date(), closingTime: Date(), services: nil)
//        var firebaseManager = FirebaseManager()
//        firebaseManager.updateSalon(salonId: salonId, salon: updatedSalon, image: UIImage(named: "location")) { error in
//            if let error = error {
//                print("Error updating salon: \(error.localizedDescription)")
//            } else {
//                print("Salon updated successfully!")
//            }
//        }
//    }
//
//    func testFetchAllSalons() {
//        getAllSalons { (salons, error) in
//            if let error = error {
//                print("Error fetching salons: \(error.localizedDescription)")
//            } else if let salons = salons {
//                print("Fetched \(salons.count) salons successfully!")
//                for salon in salons {
//                    print("Salon Name: \(salon.salonName)")
//                }
//            }
//        }
//    }
//
//func getAllSalons(completion: @escaping ([SalonModel]?, Error?) -> Void) {
//    let db: Firestore = Firestore.firestore()
//    db.collection("salons").getDocuments { (querySnapshot, error) in
//        if let error = error {
//            completion(nil, error)
//        } else {
//            let salons = querySnapshot?.documents.compactMap { document -> SalonModel? in
//                do {
//                    return try document.data(as: SalonModel.self)
//                } catch {
//                    print("Error decoding salon: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//            completion(salons, nil)
//        }
//    }
//}


//internal struct DPDConstant {
//
//    internal struct KeyPath {
//
//        static let Frame = "frame"
//
//    }
//
//    internal struct ReusableIdentifier {
//
//        static let DropDownCell = "DropDownCell"
//
//    }
//
//    internal struct UI {
//
//        static let TextColor = UIColor.black
//        static let SelectedTextColor = UIColor.gray
//        static let TextFont = UIFont.systemFont(ofSize: 15)
//        static let BackgroundColor = UIColor(white: 1, alpha: 0.85)
//        static let SelectionBackgroundColor = UIColor(white: 1, alpha: 0.85)
//        static let SeparatorColor = UIColor.lightGray
//        static let CornerRadius: CGFloat = 13
//        static let RowHeight: CGFloat = 44
//        static let HeightPadding: CGFloat = 5
//
//        struct Shadow {
//
//            static let Color = UIColor.darkGray
//            static let Offset = CGSize.zero
//            static let Opacity: Float = 0.4
//            static let Radius: CGFloat = 8
//
//        }
//
//    }
//
//    internal struct Animation {
//
//        static let Duration = 0.15
//        static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
//        static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
//        static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//
//    }
//
//}
