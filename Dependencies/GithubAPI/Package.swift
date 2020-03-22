// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubAPI",
    platforms: [.iOS(.v13)],
    products: [.library(name: "GithubAPI",targets: ["GithubAPI"]),],
    dependencies: [
        .package(url: "../GithubFoundation", from: "1.0.0")
    ],
    targets: [.target(name: "GithubAPI",dependencies: ["GithubFoundation"]),]
)
