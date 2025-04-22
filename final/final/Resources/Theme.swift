//
//  Theme.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//
import SwiftUI

enum Theme {
    static let purple      = Color(red: 109/255, green: 93/255,  blue: 255/255)
    static let purpleLight = Color(red: 206/255, green: 201/255, blue: 255/255)
    static let purpleDark  = Color(red: 67/255,  green: 54/255,  blue: 204/255)
    static let bg          = Color(uiColor: .systemBackground)
    static let card        = Color.white.opacity(0.95)

    static func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Montserrat-\(weight == .bold ? "Bold" : "Regular")", size: size)
    }
}
