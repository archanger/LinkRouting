# Link Routing

A library that makes SwiftUI routing easy.

> [!NOTE]
> This project is a POC showing off a declarative way to make routing in SwiftUI applications.

## Background

Even in the newest SwiftUI, making a navigation is still a challenge. For instance, if you want to push a view into the navigation stack, you have to do something like this:

```swift
NavigationLink(destination: PageView()) { Text("page") }
```

This way, we create a tight coupling between two screens. Imagine if it is possible to navigate to `PageView` from several places, and if you decide to rename the `PageVew` or replace it with another flow, it would require you to apply changes in every place, creating a huge diff.

Luckily, in iOS 16, Apple introduced `NavigationPath,` which solves the problem of pushing and popping the views. The TabBar and Sheet presentation remains the same — you cannot simply define what view to show in a single place. I hope Apple will introduce solutions to these cases as well in future versions, but for now, we have what we have.

## Solution

What if we follow the routing principles from Web applications? Overall, a mobile application is the same front-end app and boils down to rendering pages. So one route - one page.

```swift
Router(routes: [
    Route(path: "/", builder: { _ in ContentView() }),
])
```

And that's all for a single-page application. All you have to do is implement `ContentView`.

### Extendability

What if we have to add a new route? Easy-peasy:

```swift
Router(routes: [
    Route(path: "/", builder: { _ in HomeView() }),
    Route(path: "/favorites", builder: { _ in FavoritesView() }),
])
```

Now, we have two routes, and the only thing we have to do is to implement another view. As these routes are siblings, navigating from one to another would replace pages. If we want to achieve the push/pop animation, we can do it like this:

```swift
Router(routes: [
    Route(path: "/", builder: { _ in HomeView() }, children: [
        Route(path: "favorites", builder: { _ in FavoritesView() }),
    ]),
])
```

Note that we removed `/` from the path for Favorites. The Router will concatenate the paths forming the correct URL - `/`favorites`.

But as mentioned, Apple already solved the problem with reusable Views in the navigation stack, so let's pump it up.

#### Modal Presentation

If a route has to be presented modally, we can add a simple flag:

```swift
Router(routes: [
    Route(path: "/", builder: { _ in HomeView() }, children: [
        Route(path: "favorites", builder: { _ in FavoritesView() }),
        Route(path: "details", builder: { _ in DetailsView() }, isModal: true),
    ]),
])
```

And that's all that is needed to present `details` modally. As the screen is a child for the root, no matter how deep we are in the navigation wilds, we'll be dropped to the root, and a modal will be opened.

However, pushing/popping and presenting modal pages are not the only things we often use in mobile development.

#### Tab Navigation

If we want to define a tabbed application, we can do that using:

```swift
Router.tabbed(tabs: [
    TabRoute(
        path: "/",
        builder: { _ in HomeView() },
        labelBuilder: { Label("Home", systemImage: "house") },
        children: [
            Route(path: "details", builder: { _ in NamedView(text: "Details")}),
        ]
    ),
    TabRoute(
        path: "/favorites",
        builder: { _ in FavoritesView() },
        labelBuilder: { Label("Favorites", systemImage: "star") },
        children: []
    )
])
```

Now we introduce `TabRoute` which knows how to build a label in TabBar.

### Navigation

But how do we navigate?

Under the hood, the library uses `Navigator` - an observable object - which does the magic.

```swift
struct HomeView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        VStack {
            List {
                Button("open \"/favorites\"") {
                    navigator.go(to: "/favorites")
                }
                RouteLink(
                    label: {
                        Text("open \"/details\"")
                    },
                    route: "/details"
                )
            }
        }
    }
}
```

`Navigator` has a single function, `go(to:)`, which accepts a route. In addition, there is `RouteLink`, which mimics the chevron in a list item.

## Example

For more details, check the Example folder in the repository.
