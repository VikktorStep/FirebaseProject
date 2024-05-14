
import SwiftUI

struct CapsuleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 280, height: 60)
            .font(.title2)
            .bold()
            .foregroundStyle(.black)
            .background(.primaryColor3.opacity(0.9))
            .clipShape(.capsule)
    }
}
