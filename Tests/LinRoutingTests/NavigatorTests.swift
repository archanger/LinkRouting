@testable import LinkRouting
import SwiftUI
import Testing

@MainActor
@Suite
struct NavigatorTests {

    @Test
    func oneLevel() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                        Route(path: "details2", builder: { _ in Text("Details") })
                    ]
                )
            ]
        )

        sut.go(to: "/details")

        #expect(sut.path.value == "details")
    }

    @Test
    func twoLevels() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(
                            path: "details",
                            builder: { _ in Text("Details")},
                            children: [
                                Route(
                                    path: "id",
                                    builder: { _ in Text("ID")}
                                )
                            ]
                        )
                    ]
                )
            ]
        )

        sut.go(to: "/details/id")

        #expect(sut.path.value == "details/id")
    }

    @Test
    func root() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/root",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(
                            path: "details",
                            builder: { _ in Text("Details")},
                            children: [
                                Route(
                                    path: "id",
                                    builder: { _ in Text("ID")}
                                )
                            ]
                        )
                    ]
                )
            ],
            root: "/root"
        )

        sut.go(to: "/root/details/id")

        #expect(sut.path.value == "details/id")
        #expect(sut.rootPath == "/root")
    }

    @Test
    func fail() {
        #expect(throws: NavigatorError.rootPathDoesNotPresentInRoutes) {
            try Navigator(
                routes: [
                    Route(path: "/path", builder: { _ in Text("Path") })
                ],
                root: "/"
            )
        }
    }

    @Test
    func routeToNotFoundPage() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Root") },
                    children: [
                        Route(path: "details", builder: { _ in Text("Details") }),
                    ]
                )
            ]
        )

        sut.go(to: "/favorites")

        #expect(sut.path.value == "not-found")
    }

    @Test
    func modalRoutePath() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Home") },
                    children: [
                        Route(
                            path: "details",
                            builder: { _ in Text("Details") },
                            isModal: true
                        )
                    ]
                )
            ]
        )

        sut.go(to: "/details")

        #expect(sut.path.value == "")
        #expect(sut.modalPath == "details")
    }

    @Test
    func modalRoutePathThroughPush() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Home") },
                    children: [
                        Route(
                            path: "items",
                            builder: { _ in Text("Details") },
                            children: [
                                Route(
                                    path: "details",
                                    builder: { _ in Text("Details") },
                                    isModal: true
                                )
                            ]
                        )
                    ]
                )
            ]
        )

        sut.go(to: "/items/details")

        #expect(sut.path.value == "items")
        #expect(sut.modalPath == "details")
    }

    @Test
    func modalNavigatorRoutesToTarget() throws {
        let sut = try Navigator(
            routes: [
                Route(
                    path: "/",
                    builder: { _ in Text("Home") },
                    children: [
                        Route(
                            path: "details",
                            builder: { _ in Text("Details") },
                            children: [
                                Route(path: "id", builder: { _ in Text("ID") })
                            ],
                            isModal: true
                        )
                    ]
                )
            ]
        )

        sut.go(to: "/details/id")

        #expect(sut.path.value == "")
        #expect(sut.modalPath == "details/id")
        #expect(sut.modalNavigator().path.value == "id")
    }
}

extension NavigationPath {
    var value: String {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(codable)

        let array = try! JSONSerialization.jsonObject(with: jsonData) as! [String]
        let filtered = array.filter { $0.contains("{") && $0.contains("}") }
        var boxes = filtered.map { try! JSONDecoder().decode(RouteBox_.self, from: $0.data(using: .utf8)!)}

        guard !boxes.isEmpty else { return "" }

        let first = boxes.removeLast()

        return boxes.reversed().reduce(first.path) { partialResult, b in
            partialResult + "/" + b.path
        }
    }
}

struct RouteBox_: Codable {
    let path: String
}
