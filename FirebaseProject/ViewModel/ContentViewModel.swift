
import Foundation

final class ContentViewModel: ObservableObject {
    @Published var appState: ApplicationState?
    @Published var profile: Profile?
    
    init() {
        if let user = AuthService.shared.currentUser {
            Task {
                let profile = try await FirestoreService.shared.getProfile(byId: user.uid)
                DispatchQueue.main.async {
                    self.appState = .authorized(profile: profile)
                }
            }
            
        }  else {
            self.appState =  .notAuthorized
        }
    }
    
    enum ApplicationState {
        case notAuthorized
        case authorized(profile: Profile)
    }
}
