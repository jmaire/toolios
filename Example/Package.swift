//
//  Package.swift
//  toolios
//
//  Created by Julien Maire on 12/03/2025.
//  Copyright © 2022-2025 Julien Maire
//

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "toolios",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "toolios",
            targets: ["toolios"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "toolios",
            dependencies: []),
        ),
        .testTarget(
            name: "toolios_Tests",
            dependencies: ["toolios"]),
    ]
)
