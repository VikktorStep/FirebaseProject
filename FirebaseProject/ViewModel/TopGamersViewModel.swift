
import Foundation

final class TopGamersViewModel: ObservableObject {
    @Published var gamers: [Profile] = []
    
    var yourResult: (score: Int, place: Int) {
        guard let currentUserID = AuthService.shared.currentUser?.uid else { return (0, 0) }
        
        if let profile = gamers.first(where: { $0.id == currentUserID }),
           let place = gamers.firstIndex(where: { $0.id == currentUserID }) {
            return (profile.allMoney, place + 1)
        }
        
        return (0, 0)
    }
    
    init() {
        getData()
    }
    
    func getData() {
        Task {
            do {
                let profiles = try await FirestoreService.shared.getAllProfiles()
                DispatchQueue.main.async { self.gamers = profiles }
            } catch {
                print("Failed to fetch profiles: \(error)") //TODO: Alert
            }
        }
    }
}
