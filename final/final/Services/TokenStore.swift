//
//  TokenStore.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation

final class TokenStore {
    private enum Keys { static let access = "wheelix.access" }
    static let shared = TokenStore()
    private init() {}

    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.access) }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: Keys.access)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.access)
            }
        }
    }
}
