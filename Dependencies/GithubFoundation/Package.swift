// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubFoundation",
    platforms: [.iOS(.v13)],
    products: [ .library( name: "GithubFoundation", targets: ["GithubFoundation"]),],
    targets: [ .target( name: "GithubFoundation", dependencies: []), ]
)
