// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "rpgAltranAPI",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),
        // .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),

        // 🔐 Auth (adding security
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.2.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "Authentication", "Crypto"]),
        .target(name: "Run", dependencies: ["App"]),
    ]
)
