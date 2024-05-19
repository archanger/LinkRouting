import LinkRouting
import SwiftUI

struct ParameterizedView: View {
    @Environment(Navigator.self) var navigator
    @State private var text: String = ""

    var body: some View {
        HStack {
            Button("open \"/details/") {
                navigator.go(to: "/details/\(text)")
            }
            TextField("dynamic route", text: $text)
        }
    }
}

#Preview {
    Router.singleRooted(content: ParameterizedView.init)
}
