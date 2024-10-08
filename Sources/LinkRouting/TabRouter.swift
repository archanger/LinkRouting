import SwiftUI

@MainActor
struct TabRouter: View {
    @State private var navigator: TabNavigator
    let routes: [AnyTabRouteProtocol]

    init(routes: [AnyTabRouteProtocol], rootPath: String?) {
        self.navigator = try! TabNavigator(tabs: routes, rootPath: rootPath ?? routes.first?.path ?? "/")
        self.routes = routes
    }

    var body: some View {
        TabView(selection: $navigator.rootPath) {
            ForEach(navigator.navigators, id: \.rootPath) { nav in
                Router(navigator: nav)
                    .tabItem {
                        routes.first { route in
                            route.path == nav.rootPath
                        }?.buildLabel()
                    }
                    .tag(nav.root?.route.pathComponent)
            }
        }
        .environment(navigator)
    }
}
