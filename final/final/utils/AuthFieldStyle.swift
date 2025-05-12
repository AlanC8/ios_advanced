//
//  AuthFieldStyle.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import SwiftUI

struct AuthFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(.black)
            .font(.montserrat(.medium, size: 16))
    }
}
