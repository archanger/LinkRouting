import SwiftUI

@MainActor
public struct RouteLink<Label: View>: View {
    @Environment(Navigator.self) var nav
    let label: () -> Label
    let route: String

    public init(@ViewBuilder label: @escaping () -> Label, route: String) {
        self.label = label
        self.route = route
    }

    public var body: some View {
        HStack {
            label()
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(Font.system(size: 13))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            nav.go(to: route)
        }
    }
}
