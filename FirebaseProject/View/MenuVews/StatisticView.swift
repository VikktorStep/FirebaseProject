
import SwiftUI

struct StatisticView: View {
    @StateObject var viewModel: StatisticViewModel
    
    var body: some View {
        List(viewModel.games) { game in
            GameCell(viewModel: .init(game: game))
        }.listStyle(.plain)
    }
}
