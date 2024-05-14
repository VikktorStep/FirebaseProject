
import FirebaseStorage
import Foundation

final class StorageService {
    
    static let shared = StorageService(); private init() { }
    private let storage = Storage.storage().reference()
    private var profilePictures: StorageReference { storage.child("ProfilePictures") }
    
    func upload(_ data: Data, byUserId userID: String) async throws {
        let path = profilePicturePath(id: userID)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = try await path.putDataAsync(data, metadata: metadata)
    }
    
    func downloadProfilePicture(_ userID: String) async throws -> Data {
        let path = profilePicturePath(id: userID)
        let result = try await path.data(maxSize: 1 * 1024 * 1024)
        return result
    }
    
    private func profilePicturePath(id: String) -> StorageReference { profilePictures.child("\(id).jpg") }
}

