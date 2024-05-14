
import Foundation

final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPass = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var authComplete = false
    @Published var profile: Profile?
    
    func auth() {
        Task {
            let profile = try await AuthService.shared.signIn(email: email, password: password)
            DispatchQueue.main.async {
                self.profile = profile
                self.authComplete = true
            }
        }
    }
    
    func registration() {
        guard password == confirmPass else {
            self.alertMessage = "Пароли не совпадают"
            self.showAlert.toggle()
            return
        }
        
        Task {
            do {
                let profile = try await AuthService.shared.createAccount(email: email, password: password)
                DispatchQueue.main.async {
                    self.profile = profile
                    self.authComplete = true
                }
            } catch {
                if error.localizedDescription == "The email adress is already in use by another account" {
                    DispatchQueue.main.async {
                        self.alertMessage = "Такой пользователь уже существует"
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
