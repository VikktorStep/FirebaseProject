
import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    @EnvironmentObject private var contentVM: ContentViewModel
    @State private var isAuth: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Authorization")
                .font(.title).bold()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(.capsule)
            
            VStack {
                TextField("Email", text: $viewModel.email)
                    .modifier(TextFieldModifier())
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(SecureFieldModifier())
                
                if !isAuth {
                    SecureField("Confirm password", text: $viewModel.confirmPass)
                    .modifier(SecureFieldModifier())
                }
                
                Button(isAuth ? "Log In" : "Create Account") {
                    isAuth ? viewModel.auth() : viewModel.registration()
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(.primaryColor3)
                .clipShape(.capsule)
                .padding(.horizontal)
                .foregroundStyle(.white)
                
                Button(isAuth ? "Do not have an account yet" : "Already have an account") {
                    isAuth.toggle()
                }
                .foregroundStyle(.primaryColor3)
            }
            .frame(width: isAuth ? 300 : 330)
            .padding(.vertical, 24)
            .background(.white)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: isAuth ? 0 : 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            BackgroundImage(isBlurred: isAuth)
        }
        .animation(.easeInOut, value: isAuth)
        
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text(viewModel.alertMessage),
                  message: nil,
                  dismissButton: .cancel(Text("Ok")))
        })
        
        .onChange(of: viewModel.authComplete) {
            contentVM.profile = viewModel.profile
            if let profile = viewModel.profile {
                contentVM.appState = .authorized(profile: profile)
            }
        }
    }
}

#Preview {
    AuthView()
}

private struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.white)
            .clipShape(.capsule)
            .shadow(radius: 4)
            .padding(.horizontal)
    }
}

private struct SecureFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.white)
            .clipShape(.capsule)
            .shadow(radius: 4)
            .padding(.horizontal)
    }
}


