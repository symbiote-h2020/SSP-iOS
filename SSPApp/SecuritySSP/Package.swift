// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SecuritySSP",
    dependencies: [
        // 🔑 JWT
        .package(url: "https://github.com/vapor/jwt.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SecuritySSP", dependencies: ["JWT"], path: "."),
    ]
)
