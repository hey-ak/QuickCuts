import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
//        static let BackgroundColor = UIColor(white: 1, alpha: 0.8)
//        static let SelectionBackgroundColor = UIColor(white: 1, alpha: 0.8)
//        static let SeparatorColor = UIColor.lightGray
//        static let CornerRadius: CGFloat = 13
//        static let RowHeight: CGFloat = 30
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
