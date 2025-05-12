//
//  Font+Montserrat.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import SwiftUI

enum MontserratWeight: String {
    case black      = "Montserrat-Black"
    case bold       = "Montserrat-Bold"
    case extraBold  = "Montserrat-ExtraBold"
    case semiBold   = "Montserrat-SemiBold"
    case medium     = "Montserrat-Medium"
    case regular    = "Montserrat-Regular"
    case light      = "Montserrat-Light"
    case extraLight = "Montserrat-ExtraLight"
    case thin       = "Montserrat-Thin"
}

extension Font {
    static func montserrat(
        _ weight: MontserratWeight = .regular,
        size: CGFloat,
        relativeTo style: TextStyle? = nil
    ) -> Font {
        if let style = style {
            return .custom(weight.rawValue, size: size, relativeTo: style)
        } else {
            return .custom(weight.rawValue, size: size)
        }
    }
}
