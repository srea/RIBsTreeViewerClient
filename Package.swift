// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "RIBsTreeViewerClient",
    platforms: [.iOS(.v13)],
    products: [
            .library(name: "RIBsTreeViewerClient", targets: ["RIBsTreeViewerClient"]),
        ],
        dependencies: [
            .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0"),
            .package(url: "https://github.com/uber/RIBs.git", from: "0.9.2"),
        ],
        targets: [
        .target(
            name: "RIBsTreeViewerClient",
            path: "./RIBsTreeViewerClient/Sources"
        ),
    ]
)
