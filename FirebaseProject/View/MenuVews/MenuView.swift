
import SwiftUI
import PhotosUI

struct MenuView: View {
    @StateObject var viewModel: MenuViewModel
    @EnvironmentObject var contentVM: ContentViewModel
    @State var showGameView = false
    @State var showStatisticView = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Заработано:")
                    
                    Text("\(viewModel.allMoney) ₽")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Сыграно:")
                    
                    Text("\(viewModel.gamesCount) игр")
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .foregroundStyle(.white)
            
            Text("Вопросник")
                .headerTextStyle()
            
            PhotosPicker(selection: $viewModel.pickerItem,
                         matching: .images) {
                if let imageData = viewModel.imageData,
                   let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 176, height: 176).fontWeight(.ultraLight)
                        .clipShape(.circle)
                        .padding(.top, 20)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 160, height: 160).fontWeight(.ultraLight)
                        .padding(8)
                        .background(.white)
                        .clipShape(.circle)
                        .padding(.top, 20)
                }
            } .onAppear {
                viewModel.getGames()
            }
            .onChange(of: viewModel.pickerItem) {
                viewModel.processPhoto()
            }
            .tint(.black)
            
            
            Text("\(viewModel.profile.name)")
                .font(.title)
                .frame(width: 280, height: 60)
                .background {
                    Color.white.opacity(0.3).blur(radius: 3.0)
                }
                .clipShape(.capsule)
            
            Button("Начать игру") {
                showGameView.toggle()
            }
            .modifier(CapsuleModifier())
            
            NavigationLink("Моя статистика") {
                StatisticView(viewModel: .init(games: viewModel.games))
            }
            .modifier(CapsuleModifier())
            
            NavigationLink("Топ игроков") {
                TopGamersView()
            }
            .modifier(CapsuleModifier())
            
            Button("Выйти") {
                viewModel.quitAccaunt()
                contentVM.appState = .notAuthorized
            }
            .modifier(CapsuleModifier())
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            BackgroundImage(isBlurred: true)
        }
        .fullScreenCover(isPresented: $showGameView) {
            GameView(viewModel: .init(profile: viewModel.profile))
                .environmentObject(viewModel)
        }
    }
}

private extension View {
    func headerTextStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.5))
            .padding(.top)
            .font(.largeTitle)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
}


