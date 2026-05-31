// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RIBsTreeViewerClient",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "RIBsTreeViewerClient", targets: ["RIBsTreeViewerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/uber/RIBs-iOS.git", from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "6.9.0"..<"7.0.0"),
    ],
    targets: [
        .target(
            name: "RIBsTreeViewerClient",
            dependencies: [
                .product(name: "RIBs", package: "RIBs-iOS"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "RIBsTreeViewerClient/Sources"
        ),
    ]
)
