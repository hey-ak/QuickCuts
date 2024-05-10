import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        handleAuthNavigation()
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    private func handleAuthNavigation() {
        if Auth.auth().currentUser != nil {
            GoToHomeVC()
        } else {
            GoToSigninVC()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

func GoToSigninVC(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc =  storyboard.instantiateViewController(withIdentifier: "SignInVC")
    if let window = GetWindow(){
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

func GoToHomeVC(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc =  storyboard.instantiateViewController(withIdentifier: "CustomTabbarVC")
    if let window = GetWindow(){
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

func GetWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return sceneDelegate?.window ?? appDelegate?.window
    } else {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window
    }
}
