
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        switch viewModel.appState {
        case .notAuthorized:
            AuthView()
                .environmentObject(viewModel)
        case .authorized(let profile):
            NavigationStack {
                MenuView(viewModel: .init(profile: profile))
                    .environmentObject(viewModel)
                    .toolbar(.hidden, for: .navigationBar)
            }
        default:
            LoadingView()
        }
    }
}

#Preview {
    ContentView()
}
