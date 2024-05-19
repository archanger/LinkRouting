import SwiftUI

public protocol AnyRouteProtocol {
    var path: String { get }
    var children: [AnyRouteProtocol] { get }
    var isModal: Bool { get }
    func build(slug: String?) -> AnyView
}

public protocol AnyTabRouteProtocol: AnyRouteProtocol {
    func buildLabel() -> AnyView
}