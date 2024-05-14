
import Foundation

final class GameCellViewModel: ObservableObject {
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    func date() -> String {
        let date = game.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let str = formatter.string(from: date)
        return str
    }
}
