//
//  AuthViewModel.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//


import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var error: String?

    @Published var isRegisterMode = false

    private let api = AuthService()
    private let tokenStore = TokenStore.shared

    func submit() {
        Task {
            isLoading = true; defer { isLoading = false }
            do {
                if isRegisterMode {
                    try await api.register(username: username,
                                           email: email,
                                           password: password)
                }
                let token = try await api.login(username: username,
                                                password: password)
                tokenStore.save(token)
            } catch {
                self.error = "Ошибка: \(error.localizedDescription)"
            }
        }
    }
}
