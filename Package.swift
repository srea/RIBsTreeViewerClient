// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "RIBsTreeViewerClient",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "RIBsTreeViewerClient", targets: ["RIBsTreeViewerClient"]),
    ],
    targets: [
        .target(
            name: "RIBsTreeViewerClient",
            path: "./RIBsTreeViewerClient/Sources"
        ),
    ]
)
