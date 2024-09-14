@testable import LinkRouting
import SwiftUI
import Testing

@MainActor
@Suite
struct TabNavigatorTests {
    @Test
    func switchTabWithFurtherPush() throws {
        let sut = try TabNavigator(
            tabs: [
                Route(
                    path: "/favorites",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/home",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/account",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                )
            ],
            rootPath: "/home"
        )

        sut.go(to: "/favorites/details2")

        #expect(sut.rootPath == "/favorites")
        #expect(sut.navigators[0].path.value == "details2")
    }

    @Test
    func switchTabWithParameterizedPathPush() throws {
        let sut = try TabNavigator(
            tabs: [
                Route(
                    path: "/favorites",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: ":id", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/home",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/account",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                )
            ],
            rootPath: "/home"
        )

        sut.go(to: "/favorites/details2")

        #expect(sut.rootPath == "/favorites")
        #expect(sut.navigators[0].path.value == "details2")
    }

    @Test
    func routeToUnknownPath() throws {
        let sut = try TabNavigator(
            tabs: [
                Route(
                    path: "/favorites",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/home",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                ),
                Route(
                    path: "/account",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                )
            ],
            rootPath: "/home"
        )

        sut.go(to: "/shop")

        #expect(sut.rootPath == "/home")
        #expect(sut.navigators[1].path.value == "not-found")
    }
}
