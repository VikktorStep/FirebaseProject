
import SwiftUI

struct BackgroundImage: View {
    var isBlurred: Bool
    
    var body: some View {
        Image(.bg)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .blur(radius: isBlurred ? 0 : 12, opaque: true)
    }
}
