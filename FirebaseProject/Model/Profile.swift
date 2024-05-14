
import Foundation
import FirebaseFirestore

final class Profile: Identifiable {
    var id: String
    var name: String
    var games: [Game] = []
    
    var allMoney: Int {
        var sum = 0
        for game in self.games {
            sum += game.money
        }
        return sum
    }
    
    init(id: String, name: String = "Новый игрок") {
        self.name = name
        self.id = id
    }
}

extension Profile {
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        
        return repres
    }
}

extension Profile {
    convenience init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else { return nil }
        guard let id = data["id"] as? String,
              let name = data["name"] as? String
        else { return nil }
        
        self.init(id: id, name: name)
    }
}


