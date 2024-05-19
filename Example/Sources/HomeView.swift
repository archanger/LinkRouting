import LinkRouting
import SwiftUI

struct HomeView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        VStack {
            List {
                Button("open \"/favorites\"") {
                    navigator.go(to: "/favorites")
                }
                RouteLink(
                    label: {
                        Text("open \"/details\"")
                    },
                    route: "/details"
                )
                Button("say \"/hi\" modally") {
                    navigator.go(to: "/hi")
                }
                ParameterizedView()
            }
        }
    }
}

#Preview {
    Router.singleRooted(content: HomeView.init)
}
