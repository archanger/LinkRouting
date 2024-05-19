import SwiftUI

public struct Route<Content: View>: AnyRouteProtocol {
    public let path: String
    let builder: (String?) -> Content
    public let children: [AnyRouteProtocol]
    public let isModal: Bool

    public init(
        path: String,
        @ViewBuilder builder: @escaping (String?) -> Content,
        children: [AnyRouteProtocol] = [],
        isModal: Bool = false
    ) {
        self.path = path
        self.builder = builder
        self.children = children
        self.isModal = isModal
    }

    public func build(slug: String?) -> AnyView {
        AnyView(builder(slug))
    }
}

public struct TabRoute<Content: View, Label: View>: AnyTabRouteProtocol {
    public var path: String
    public let isModal = false
    public var children: [any AnyRouteProtocol]

    let builder: (String?) -> Content
    let labelBuilder: () -> Label

    public init(
        path: String,
        @ViewBuilder builder: @escaping (String?) -> Content,
        @ViewBuilder labelBuilder: @escaping () -> Label,
        children: [any AnyRouteProtocol]
    ) {
        self.path = path
        self.children = children
        self.builder = builder
        self.labelBuilder = labelBuilder
    }

    public func build(slug: String?) -> AnyView {
        AnyView(builder(slug))
    }

    public func buildLabel() -> AnyView {
        AnyView(labelBuilder())
    }
}
