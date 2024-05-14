
import SwiftUI

struct TopGamersView: View {
    @StateObject var viewModel = TopGamersViewModel()
    
    var body: some View {
        VStack {
            Text("Ваше место: \(viewModel.yourResult.place)")
            
            Text("Ваш результат: \(viewModel.yourResult.score) ₽")
            
            List(viewModel.gamers) { gamer in
                HStack {
                    Text(gamer.name)
                    
                    Spacer()
                    
                    Text("\(gamer.allMoney)")
                }
            }.listStyle(.plain)
        }
    }
}
