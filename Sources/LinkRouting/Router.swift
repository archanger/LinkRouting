import SwiftUI

@MainActor
public struct Router: View {
    @State private var navigator: Navigator

    static public func tabbed(tabs: [AnyTabRouteProtocol], rootPath: String? = nil) -> some View {
        TabRouter(routes: tabs, rootPath: rootPath)
    }

    public init(routes: [AnyRouteProtocol], root: String = "/") {
        self.navigator = try! Navigator(routes: routes, root: root)
    }

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            if let box = navigator.root {
                box.route.build(box.parameters)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationDestination(for: RouteBox.self, destination: { box in
                        box.route.build(box.parameters)
                    })
            } else {
                AnyView(Text("404: Page Not Found"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environment(navigator)
        .sheet(
            item: $navigator.modalPath,
            content: {
                Router(navigator: navigator.modalNavigator()).id($0)
            }
        )
        .onOpenURL { url in
            navigator.go(to: url.host().map { "/" + $0 + url.path() } ?? "/")
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: Self { self }
}
