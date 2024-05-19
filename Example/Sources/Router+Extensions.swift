import LinkRouting
import SwiftUI

#if DEBUG
extension Router {
    static func singleRooted<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Self {
        Router.init(routes: [Route(path: "/", builder: { _ in content() })])
    }
}
#endif
