
import FirebaseAuth

final class AuthService {
    static let shared = AuthService(); private init() {}
    private let auth = Auth.auth()
    var currentUser: User? { auth.currentUser }
    
    func signIn(email: String, password: String) async throws -> Profile {
        let result = try await auth.signIn(withEmail: email, password: password)
        let user = result.user
        let profile =  try await FirestoreService.shared.getProfile(byId: user.uid)
        return profile
    }
    
    func createAccount(email: String, password: String) async throws -> Profile {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = result.user
        let profile = Profile(id: user.uid)
        try await FirestoreService.shared.createNew(profile: profile)
        return profile
    }
    
    func signOut() {
        try? auth.signOut()
    }
}
