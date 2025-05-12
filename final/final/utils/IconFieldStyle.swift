//
//  IconFieldStyle.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//


import SwiftUI

struct IconFieldStyle: ViewModifier {
    let sf: String
    func body(content: Content) -> some View {
        HStack(spacing: 14) {
            Image(systemName: sf)
                .foregroundColor(.accent)
            content
                .font(.montserrat(.medium, size: 16))
                .foregroundColor(.text)
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}
extension View {
    func iconField(_ sf: String) -> some View { modifier(IconFieldStyle(sf: sf)) }
}
