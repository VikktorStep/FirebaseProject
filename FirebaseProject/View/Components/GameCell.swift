
import SwiftUI

struct GameCell: View {
    @StateObject var viewModel: GameCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.date())
                    .multilineTextAlignment(.leading)
                
                Text("\(viewModel.game.money) ₽")
                    .frame(width: 150)
                
                Spacer()
                
                Text("Вопрос: \(viewModel.game.questionNumber)")
                    .frame(width: 100)
            }
            Text(viewModel.game.result.rawValue)
        }
    }
    

}

#Preview {
    GameCell(viewModel: .init(game: .init(questionNumber: 15,
                                          result: .quit,
                                          money: 1000000)))
}
