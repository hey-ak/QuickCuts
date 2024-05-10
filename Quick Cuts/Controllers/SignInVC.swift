import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func forgotPassDidTapped(_ sender: Any) {
        handleForgotPass()
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        handleSignIN(emailTextField.text,
                     passwordTextField.text)
    }
    
    @IBAction func dontHaveAccButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func handleForgotPass() {
        Auth.auth().sendPasswordReset(withEmail: "sam@yopmail.com") { error in

            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            DispatchQueue.main.async {
                self.showToast("Forget Pass started.")
            }
        }
    }
    
    private func handleSignIN(_ email:String?,
                              _ password:String?) {
        
        let data = ValidatableData(email: email,
                                   name: "name",
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
        
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { user, error in
            
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            guard let userData = user else { return }
            
            DispatchQueue.main.async {
                self.showToast("Account logined in sucessfully.")
                
                guard let userId = user?.user.uid else { return }
                AppDataManager.shared.saveLoggedUserID(userId)
                

                GoToHomeVC()
                
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
