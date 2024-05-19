struct RouteBox: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(route.pathComponent)
    }

    static func == (lhs: RouteBox, rhs: RouteBox) -> Bool {
        lhs.route.pathComponent == rhs.route.pathComponent
    }

    let route: Crumb
    let slug: String?

    init(slug: String?, route: Crumb) {
        self.route = route
        self.slug = slug
    }
}

extension RouteBox: Codable {
    enum CodingKeys: String, CodingKey {
        case path
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(route.pathComponent, forKey: .path)
    }

    init(from decoder: any Decoder) throws {
        fatalError("Not implemented")
    }
}