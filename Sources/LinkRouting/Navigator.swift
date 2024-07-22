import SwiftUI

public enum NavigatorError: Error {
    case rootPathDoesNotPresentInRoutes
}

@MainActor
@Observable
public class Navigator {
    var path = NavigationPath()
    let map: [RoutePath]
    var modalPath: String?
    var rootPath: String

    private(set) var root: RouteBox?

    private let parentNavigator: Navigator?
    private var modalMap: [RoutePath]?
    private var modalRoot: String?

    init(routes: [AnyRouteProtocol], root: String = "/", parent: Navigator? = nil, initialSlug: String? = nil) throws {
        self.rootPath = root
        guard let root = routes.first(where: { $0.path == root }) else {
            throw NavigatorError.rootPathDoesNotPresentInRoutes
        }
        self.parentNavigator = parent
        self.root = RouteBox(slug: initialSlug, route: Crumb(pathComponent: root.path, isModal: root.isModal, build: root.build))
        self.map = _BuildMap(routes: routes)
    }

    init(map: [RoutePath], rootPath: String, parent: Navigator? = nil) {
        self.rootPath = rootPath
        self.parentNavigator = parent
        self.map = map
    }

    func modalNavigator() -> Navigator {
        let modalRoot = modalRoot ?? "/"
        let nav = Navigator(
            map: modalMap ?? [],
            rootPath: modalRoot,
            parent: self
        )
        nav.go(to: modalPath ?? "/")
        return nav
    }

    public func go(to path: String) {
        go(to: path, caller: nil)
    }

    func go(to path: String, caller: Navigator? = nil) {
        let relativePath = (path.hasSuffix("/" + rootPath) ? rootPath : nil)
            ?? path.range(of: rootPath + "/").map { String(path[$0.lowerBound...]) }
        let routes = findRoute(map: map, path: relativePath ?? path)

        guard
            let routes
        else {
            if let parent = parentNavigator {
                parent.go(to: path, caller: self)
            } else {
                // TODO: parameterize NotFound
                (caller ?? self).path.append(
                    RouteBox(slug: nil, route: Crumb(
                        pathComponent: "not-found",
                        isModal: false,
                        build: { _ in AnyView(Text("404: Page Not Found")) }
                    )))
            }
            return
        }

        rootPath = routes.first?.0 ?? self.rootPath
        root = routes.first.map { RouteBox(slug: $0.0, route: $0.1) }

        let path = routes.dropFirst()
        if let modalIndex = path.firstIndex(where: { $0.1.isModal == true }) {
            let navPath = path.prefix(modalIndex-1)
            self.path = NavigationPath(navPath.map(RouteBox.init))

            let newCrumbs = [path[modalIndex]] + path.dropFirst(modalIndex)

            let prev = ([rootPath] + path.prefix(modalIndex).map(\.1.pathComponent))
                .joined(separator: "/")
                .replacingOccurrences(of: "//", with: "/")

            modalPath = newCrumbs.map { $0.0 ?? $0.1.pathComponent }.joined(separator: "/")

            modalRoot = path[modalIndex].1.pathComponent

            modalMap = map.filter { $0.path.hasPrefix(prev) }.map { routePath in
                let newCrumbs = routePath.crumbs.drop { $0.pathComponent != modalRoot}
                return RoutePath(path: newCrumbs.map(\.pathComponent).joined(separator: "/"), crumbs: Array(newCrumbs))
            }
        } else {
            self.modalMap = nil
            self.modalPath = nil
            self.path = NavigationPath(path.map(RouteBox.init))
        }
    }
}

struct Crumb {
    let pathComponent: String
    let isModal: Bool
    let build: (String?) -> AnyView
}

struct RoutePath {
    let path: String
    let crumbs: [Crumb]
}

@MainActor
func _BuildMap(routes: [AnyRouteProtocol]) -> [RoutePath] {
    routes.map { _buildMap(route: $0) }.flatMap { $0 }
}

@MainActor
func _buildMap(route: AnyRouteProtocol) -> [RoutePath] {
    let currentCrumb = Crumb(pathComponent: route.path, isModal: route.isModal, build: route.build)

    return route.children.map {
        _buildMap(route: $0).map { child in
            RoutePath(
                path: (route.path + "/" + child.path).replacingOccurrences(of: "//", with: "/"),
                crumbs: [currentCrumb] + child.crumbs
            )
        }
    }.flatMap { $0 } + [RoutePath(path: route.path, crumbs: [currentCrumb])]
}

func findRoute(map: [RoutePath], path: String) -> [(String?, Crumb)]? {
    map.map { extract(pattern: $0, path: path) }.first(where: { $0 != nil }) ?? nil
}

func extract(pattern: RoutePath, path: String) -> [(String?, Crumb)]? {
    var pathComponents = path.splitIncludingRoot()
    let components = pattern.crumbs

    var result: [(String?, Crumb)] = []

    for component in components {
        if component.pathComponent.contains(":") {
            var param: String? = nil
            for sc in component.pathComponent.splitIncludingRoot() {
                if pathComponents.isEmpty { return nil }
                if sc.hasPrefix(":") {
                    param = String(pathComponents[0])
                    pathComponents = Array(pathComponents.dropFirst())
                } else {
                    pathComponents = Array(pathComponents.dropFirst())
                }
            }
            result.append((param, component))
        } else {
            let subComponents = component.pathComponent.splitIncludingRoot()
            for sc in subComponents {
                if pathComponents.isEmpty { return nil }
                if pathComponents[0] == sc {
                    pathComponents = Array(pathComponents.dropFirst())
                } else {
                    return nil
                }
            }
            result.append((nil, component))
        }
    }

    return pathComponents.isEmpty ? result : nil
}

private extension String {
    func splitIncludingRoot() -> [String] {
        if hasPrefix("/") {
            return ["/"] + split(separator: "/").map(String.init)
        }

        return split(separator: "/").map(String.init)
    }
}
