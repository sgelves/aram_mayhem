//
//  Color+Custom.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 3/10/26.
//

import SwiftUI

extension Color {
    // MARK: - Base (dark)
    static let abyssNight = Color(hex: 0x0B1020)    // background
    static let deepIce = Color(hex: 0x141A2E)       // cards, sheets
    static let glacierSlate = Color(hex: 0x1C2440)  // selected, chips
    static let frozenSteel = Color(hex: 0x2A3352)   // borders
    static let snowlight = Color(hex: 0xF2F4FA)     // primary text
    static let mist = Color(hex: 0xA7B0C8)          // secondary text
    static let fog = Color(hex: 0x6B7592)           // tertiary / disabled

    // MARK: - Accents
    static let frostCyan = Color(hex: 0x3FD0E0)         // primary
    static let frostCyanPressed = Color(hex: 0x2BA9B8)
    static let forgeEmber = Color(hex: 0xFF7A3D)        // anvil-related
    static let forgeEmberGlow = Color(hex: 0xFF7A3D).opacity(0.35)

    // MARK: - Tiers
    static let tierSilver = Color(hex: 0xB8C2D3)
    static let tierSilverDark = Color(hex: 0x7E8AA0)
    static let tierGold = Color(hex: 0xF2B63D)
    static let tierGoldDark = Color(hex: 0xC98A1B)
    static let prismaticViolet = Color(hex: 0x9B5CFF)
    static let prismaticPink = Color(hex: 0xFF5FA2)
    static let prismaticCyan = Color(hex: 0x3FD0E0)

    /// Prismatic gradient, 135° (top-leading → bottom-trailing).
    static let prismaticGradient = LinearGradient(
        colors: [.prismaticViolet, .prismaticPink, .prismaticCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Status
    static let statusSuccess = Color(hex: 0x4ADE80)
    static let statusWarning = Color(hex: 0xFBBF24)
    static let statusError = Color(hex: 0xF87171)

    // MARK: - Light mode (secondary)
    static let lightBackground = Color(hex: 0xF4F6FB)
    static let lightSurface = Color(hex: 0xFFFFFF)
    static let lightElevated = Color(hex: 0xE9EDF6)
    static let lightBorder = Color(hex: 0xD5DBE8)
    static let lightTextPrimary = Color(hex: 0x0B1020)
    static let lightTextSecondary = Color(hex: 0x4A5470)
}

extension Color {
    /// Creates an sRGB color from a 24-bit hex value, e.g. `0x3FD0E0`.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
