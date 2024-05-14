
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primaryColor3))
            .scaleEffect(2.0, anchor: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { }
            }
    }
}

#Preview {
    LoadingView()
}
