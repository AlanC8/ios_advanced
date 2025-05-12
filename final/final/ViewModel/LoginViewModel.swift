//
//  LoginViewModel.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var phone = ""
    @Published var password = ""
    @Published var loading = false
    @Published var alertItem: AlertItem?
    
    private let auth: AuthService
    private let router: AppRouter
    
    init(auth: AuthService = AuthServiceImpl(), router: AppRouter) {
        self.auth = auth
        self.router = router
    }
    
    func login() {
        // 1. Валидация
        guard Self.isValidKZ(phone) else {
            alertItem = .init(message: "Введите номер в формате +7XXXXXXXXXX")
            return
        }
        guard password.count >= 6 else {
            alertItem = .init(message: "Пароль минимум 6 символов")
            return
        }
        
        // 2. Запрос
        loading = true
        Task {
            do {
                try await auth.login(LoginDTO(identifier: phone, password: password))
                router.navigateToHome()
            } catch {
                alertItem = .init(message: "Неверный логин или сервер недоступен")
            }
            loading = false
        }
    }
    
    // MARK: - Helpers
    private static func isValidKZ(_ num: String) -> Bool {
        // +7 и ровно 11 цифр после «7»
        let pattern = #"^\+7\d{10}$"#
        return num.range(of: pattern, options: .regularExpression) != nil
    }
    
    func goToRegister() {
        router.navigateToRegister()
    }
}
