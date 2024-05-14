
import Foundation

final class StatisticViewModel: ObservableObject {
    var games: [Game]
    
    init(games: [Game]) {
        self.games = games
    }
}
