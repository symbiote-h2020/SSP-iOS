// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SecuritySSP",
    products: [
        .library(name: "SecuritySSP", targets: ["SecuritySSP"]),
    ],
    dependencies: [
    	.package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc.2.1.2"),
        //.package(url: "https://github.com/cbaker6/CertificateSigningRequestSwift.git", from: "0.0.0")
    ],
    targets: [
        .target(name: "SecuritySSP", dependencies: ["JWT", "SwiftyJSON"])
    ]
)
