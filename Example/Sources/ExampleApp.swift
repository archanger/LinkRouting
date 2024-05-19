import LinkRouting
import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            Router.tabbed(tabs: [
                TabRoute(
                    path: "/",
                    builder: { _ in HomeView() },
                    labelBuilder: { Label("Home", systemImage: "house") },
                    children: [
                        Route(path: "details", builder: { _ in NamedView(text: "Details")}),
                        Route(path: "hi", builder: { _ in NamedView(text: "Details")}, isModal: true),
                        Route(path: "details/:id", builder: { param in NamedView(text: param ?? "No param")}),
                    ]
                ),
                TabRoute(
                    path: "/favorites",
                    builder: { _ in FavoritesView() },
                    labelBuilder: { Label("Favorites", systemImage: "star") },
                    children: []
                )
            ])
        }
    }
}
