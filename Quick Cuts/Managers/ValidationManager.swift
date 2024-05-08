import Foundation


enum ValidationErrorType {
    case email
    case name
    case password
}

struct ValidatedData {
    let email: String?
    let name: String?
    let password: String?
    let errorType: ValidationErrorType?
    let errorMessage: String?
}

final class Validator {
    static let shared = Validator()
    
    private init() {}
    
    func validate(data: ValidatableData) -> ValidatedData {
        let emailError = validateEmail(data.email)
        let nameError = validateName(data.name)
        let passwordError = validatePassword(data.password)
        
        if emailError != nil || nameError != nil || passwordError != nil {
            let errorMessage = [emailError, nameError, passwordError].compactMap { $0 }.joined(separator: "\n")
            return ValidatedData(email: data.email, name: data.name, password: data.password, errorType: .email, errorMessage: errorMessage)
        }
        
        return ValidatedData(email: data.email, name: data.name, password: data.password, errorType: nil, errorMessage: nil)
    }
    
    private func validateEmail(_ email: String?) -> String? {
        guard let email = email, !email.isEmpty else {
            return "Email is required"
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            return "Invalid email format"
        }
        return nil
    }
    
    private func validateName(_ name: String?) -> String? {
        guard let name = name, !name.isEmpty else {
            return "Name is required"
        }
        return nil
    }
    
    private func validatePassword(_ password: String?) -> String? {
        guard let password = password, !password.isEmpty else {
            return "Password is required"
        }
        return nil
    }
}

struct ValidatableData {
    let email: String?
    let name: String?
    let password: String?
}
