
import Foundation
import FirebaseFirestore

final class Game: Identifiable {
    var id = UUID().uuidString
    var questionNumber: Int
    var result: GameResult
    var money: Int
    var date = Date()
    
    init(id: String = UUID().uuidString, questionNumber: Int, result: GameResult, money: Int, date: Date = Date()) {
        self.questionNumber = questionNumber
        self.result = result
        self.money = money
        self.id = id
        self.date = date
    }
    
    enum GameResult: String {
        case win = "Выиграл"
        case lose = "Проиграл"
        case quit = "Вышел и забрал деньги"
        
        init(rawValue: String) {
            switch rawValue {
            case "Выиграл": self = .win
            case "Проиграл": self = .lose
            default: self = .quit
            }
        }
    }
}

extension Game {
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["questionNumber"] = self.questionNumber
        repres["result"] = self.result.rawValue
        repres["money"] = self.money
        repres["date"] = Timestamp(date: self.date)
        return repres
    }
    
    convenience init?(queryDocumentSnapshot: QueryDocumentSnapshot) {
        let data = queryDocumentSnapshot.data()
        
        guard let id = data["id"] as? String,
              let questionNumber  = data["questionNumber"] as? Int,
              let resultStr = data["result"] as? String,
              let money = data["money"] as? Int,
              let timestamp = data["date"] as? Timestamp else { return nil }
        
        let result = GameResult(rawValue: resultStr)
        let date = timestamp.dateValue()
        self.init(id: id,
                  questionNumber: questionNumber,
                  result: result,
                  money: money)
    }
}
