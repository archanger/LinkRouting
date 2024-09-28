import LinkRouting
import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            Router.tabbed(tabs: [
                TabRoute(
                    path: "/home",
                    builder: { _ in HomeView() },
                    labelBuilder: { Label("Home", systemImage: "house") },
                    children: [
                        Route(path: "details", builder: { _ in NamedView(text: "Details")}),
                        Route(path: "hi", builder: { _ in NamedView(text: "Details")}, isModal: true),
                        Route(path: "hi/:id", builder: { params in NamedView(text: params["id"] ?? "OOps")}, isModal: true),
                        Route(path: "details/:id", builder: { params in NamedView(text: params["id"] ?? "No param")}, isModal: true),
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
