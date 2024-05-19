import SwiftUI

struct NamedView: View {
    let text: String

    var body: some View {
        Text(text)
    }
}

#Preview {
    NamedView(text: "Hello World")
}
