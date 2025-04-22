//
//  TokenStore.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//


import SwiftUI
import Security

@MainActor
final class TokenStore: ObservableObject {
    @Published private(set) var token: String?

    static let shared = TokenStore()         

    private let key = "habit.jwt"

    private init() {
        token = load()
    }

    func save(_ value: String) {
        token = value
        Keychain.save(key: key, value: value)
    }
    func clear() {
        token = nil
        Keychain.delete(key: key)
    }
    private func load() -> String? {
        Keychain.load(key: key)
    }
}

enum Keychain {
    static func save(key: String, value: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
        var withData = query
        withData[kSecValueData as String] = data
        SecItemAdd(withData as CFDictionary, nil)
    }
    static func load(key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecReturnData as String: true,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var out: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &out) == errSecSuccess,
              let data = out as? Data,
              let str = String(data: data, encoding: .utf8) else { return nil }
        return str
    }
    static func delete(key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
    }
}
