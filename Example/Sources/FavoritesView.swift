import LinkRouting
import SwiftUI

struct FavoritesView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        VStack(spacing: 16) {
            Button("open \"/details\"") {
                navigator.go(to: "/details")
            }
            Button("say \"/hi\"") {
                navigator.go(to: "/hi")
            }
            Button("open unknown page") {
                navigator.go(to: "/url/that/does/not/exist")
            }
        }
    }
}

#Preview {
    Router.singleRooted(content: FavoritesView.init)
}
