@testable import LinkRouting
import SwiftUI
import SwiftUICore
import Testing

struct RoutesExtractionTests {

    @Test
    func routesExtraction() async throws {
        let result = findRoute(
            map: [
                RoutePath(
                    path: "/details/:id",
                    crumbs: [
                        Crumb(pathComponent: "/", isModal: false, build: { _ in AnyView(Text("root")) }),
                        Crumb(pathComponent: "details", isModal: false, build: { _ in AnyView(Text("details"))}),
                        Crumb(pathComponent: ":id", isModal: false, build: { id in AnyView(Text("\(String(describing: id))")) })
                    ]
                )
            ],
            path: "/details/8888-0000"
        )

        try #require(result != nil)
        #expect(result?.count == 3)
        #expect(result![0].0 == nil)
        #expect(result![1].0 == nil)
        #expect(result![2].0 == "8888-0000")
    }

    @Test
    func routesExtractionComplex() async throws {
        let result = findRoute(
            map: [
                RoutePath(
                    path: "/details/:id/item/:id",
                    crumbs: [
                        Crumb(pathComponent: "/", isModal: false, build: { _ in AnyView(Text("root")) }),
                        Crumb(pathComponent: "details", isModal: false, build: { _ in AnyView(Text("details"))}),
                        Crumb(pathComponent: ":id", isModal: false, build: { id in AnyView(Text("\(String(describing: id))")) }),
                        Crumb(pathComponent: "item", isModal: false, build: { _ in AnyView(Text("item"))}),
                        Crumb(pathComponent: ":id", isModal: false, build: { id in AnyView(Text("\(String(describing: id))")) }),
                    ]
                )
            ],
            path: "/details/8888-0000/item/02"
        )

        try #require(result != nil)
        #expect(result?.count == 5)
        #expect(result![0].0 == nil)
        #expect(result![1].0 == nil)
        #expect(result![2].0 == "8888-0000")
        #expect(result![3].0 == nil)
        #expect(result![4].0 == "02")
    }

}
