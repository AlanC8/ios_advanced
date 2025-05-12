//
//  UnderlineField.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct UnderlineField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.fieldBorder),
                alignment: .bottom
            )
            .font(.montserrat(.medium, size: 16))
}
}
extension View { func underlineField() -> some View { modifier(UnderlineField()) } }
