
import Foundation
import PhotosUI
import SwiftUI

final class MenuViewModel: ObservableObject {
    let profile: Profile
    @Published var pickerItem: PhotosPickerItem?
    @Published var imageData: Data?
    @Published var games: [Game] = []
    @Published var newname: String = ""
    
    var gamesCount: Int { self.games.count }
    var allMoney: Int {
        var sum = 0
        for game in self.games {
            sum += game.money
        }
        return sum
    }
    
    
    init(profile: Profile) {
        self.profile = profile
        self.getProfilePicture()
    }
    
    func getProfilePicture() {
        Task { [weak self] in
            guard let self = self else { return }
            let data = try await StorageService.shared.downloadProfilePicture(profile.id)
            DispatchQueue.main.async { self.imageData = data }
        }
    }
    
    func getGames() {
        Task {
            let games = try await FirestoreService.shared.getGamesBy(userId: profile.id)
            DispatchQueue.main.async {
                self.games = games
            }
        }
    }
    
    func quitAccaunt() {
        AuthService.shared.signOut()
    }
    
    func processPhoto() {
        guard let item = pickerItem else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageData = data
                    self.sendImage()
                }
            case .failure(_):
                print("Data not exists")
            }
        }
    }
    
    func sendImage() {
        Task {
            guard let jpegData = compressImageData() else { return }
            try await StorageService.shared.upload(jpegData, byUserId: profile.id)
            DispatchQueue.main.async { self.imageData = jpegData }
        }
    }
    
    func compressImageData() -> Data? {
        guard let imageData else { return nil }
        guard let uiimage = UIImage(data: imageData) else { return nil }
        let data = uiimage.jpegData(compressionQuality: 0.1)
        return data
    }
}
