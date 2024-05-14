
import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var menuViewModel: MenuViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Button("Забрать деньги") {
                    viewModel.breakWithMoney()
                }
                .buttonStyle(BankButtonStyle())
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("В банке:")
                    Text("\(viewModel.bank) ₽")
                }
                .bankInfoStyle()
            }
            
            VStack {
                Text("\(viewModel.currentQuestionIndex + 1)")
                
                    .font(.largeTitle)
                Text("вопрос")
            }
            .padding(30)
            .background(.white.opacity(0.9))
            .clipShape(.circle)
            
            Text("Стоимость вопроса: \(viewModel.questionPrice)₽")
                .padding()
                .background(.white.opacity(0.8))
                .clipShape(.rect(cornerRadius: 12))
            
            Text(viewModel.currentQuestion?.text ?? "Вопрос не задан")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(.white.opacity(0.8))
            
            if let currentQuestion = viewModel.currentQuestion {
                VStack(spacing: 12) {
                    ForEach(currentQuestion.answers, id: \.self) { answer in
                        Button(answer) {
                            viewModel.checkAnswer(answer)
                        }
                        .frame(width: 300, height: 50)
                        .background(.primaryColor3)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .blur(radius: viewModel.showFinishAlert ? 6 : 0)
        
        .background {
            Image(.bg).resizable().scaledToFill().ignoresSafeArea()
        }
        
        .onChange(of: viewModel.gameInProcess) {
            if viewModel.gameInProcess == false { dismiss() }
        }
        
        .onChange(of: viewModel.showFinishAlert) {
            menuViewModel.getGames()
        }
        
        .overlay {
            FinishAlertOverlay(showAlert: $viewModel.showFinishAlert,
                               message: viewModel.finishAlertMessage,
                               dismissAction: self.dismiss)
        }
        .animation(.easeInOut, value: viewModel.showFinishAlert)
    }
}


struct FinishAlertOverlay: View {
    @Binding var showAlert: Bool
    let message: String
    let dismissAction: DismissAction
    
    var body: some View {
        VStack(spacing: 24) {
            Text(message)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button("Ok, до встречи!") {
                dismissAction()
            }
            .font(.title3)
            .bold()
            .backgroundStyle(Color.blue)
            .clipShape(Capsule())
            .foregroundStyle(.white)
        }
        .frame(width: 280, height: 180)
        .background(Color.white)
        .shadow(radius: 2)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .offset(y: showAlert ? 0 : 1000)
    }
}

struct BankButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 60)
            .padding()
            .background(Color.primaryColor3)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func bankInfoStyle() -> some View {
        self.frame(width: 70, height: 60)
            .padding()
            .background(Color.primaryColor3)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
