//
//  RegisterViewModel.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var phone = ""
    @Published var email = ""
    @Published var username = ""
    @Published var city = ""
    @Published var password = ""
    @Published var loading = false
    @Published var alertItem: AlertItem?

    private let auth: AuthService
    private let router: AppRouter

    init(auth: AuthService = AuthServiceImpl(), router: AppRouter) {
        self.auth = auth
        self.router = router
    }

    func register() {
        // 1. Валидация
        guard Self.isValidKZ(phone) else {
            alertItem = .init(message: "Телефон должен быть +7XXXXXXXXXX")
            return
        }
        guard Self.isValidEmail(email) else {
            alertItem = .init(message: "Некорректный e-mail")
            return
        }
        guard !username.isEmpty else {
            alertItem = .init(message: "Введите имя пользователя")
            return
        }
        guard !city.isEmpty else {
            alertItem = .init(message: "Укажите город")
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
                let dto = RegisterDTO(phone: phone,
                                      password: password,
                                      email: email,
                                      username: username,
                                      city: city)
                _ = try await auth.register(dto)
                router.rootViewController?.popViewController(animated: true)
            } catch {
                alertItem = .init(message: "Регистрация не удалась")
            }
            loading = false
        }
    }

    // MARK: - Helpers
    private static func isValidKZ(_ num: String) -> Bool {
        let pattern = #"^\+7\d{10}$"#
        return num.range(of: pattern, options: .regularExpression) != nil
    }

    private static func isValidEmail(_ mail: String) -> Bool {
        // простая RFC-совместимая проверка
        let pattern = #"^\S+@\S+\.\S+$"#
        return mail.range(of: pattern, options: .regularExpression) != nil
    }
}

