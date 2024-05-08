import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        handleSignUP(emailTextField.text,
                     passwordTextField.text,
                     nameTextField.text)
    }
    
    @IBAction func alradyMemeberDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleSignUP(_ email:String?,
                              _ password:String?,
                              _ name:String?) {
        let data = ValidatableData(email: email,
                                   name: name,
                                   password: password)
        
        let validatedData = Validator.shared.validate(data: data)
        
        guard validatedData.errorType == nil else {
            guard let errorMessage = validatedData.errorMessage
            else { return }
            
            showToast(errorMessage)
            return
        }
        
        guard let email = validatedData.email,
              let password = validatedData.password else { return }
        
        handleFirebaseAuthentication(email, password)
    }
    
    
    private func handleFirebaseAuthentication(_ email:String,
                                              _ password:String) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            guard let authResult = authResult else { return }
            let authUser = authResult.user
            
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if let error = error {
                    let errorMessage = error.localizedDescription
                    self.showToast(errorMessage)
                    return
                }
                
                DispatchQueue.main.async {
                    print(authUser)
                    self.showToast("Account creatd sucessfully.")
                }
                
            }
        }
    }
    
    private func showToast(_ message:String) {
        DispatchQueue.main.async {
            let toast = Toast.default(
                image: UIImage(named: "mark")!,
                title: message
            )
            toast.show()
        }
    }
}


class AppDataManager {
    
    static let shared = AppDataManager()
    private var db = Firestore.firestore()
    
    
    
    
    public func createUserProfile(_ userId:String) {
        do {
            let orgRef = db.collection("userProfile").document()
           // try orgRef.collection(userId).document().setData(from: )
        }
        catch {
            DispatchQueue.main.async {
                let toast = Toast.default(
                    image: UIImage(named: "mark")!,
                    title: error.localizedDescription
                )
                toast.show()
            }
        }
    }
}

//struct UserProfile
