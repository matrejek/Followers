// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubFollowers",
    platforms: [.iOS(.v13)],
    products: [
        .library( name: "GithubFollowers", targets: ["GithubFollowers"]),
    ],
    dependencies: [
        .package(url: "../GithubAPI", from: "1.0.0")
    ],
    targets: [
        .target(name: "GithubFollowers", dependencies: ["GithubAPI"]),
    ]
)
