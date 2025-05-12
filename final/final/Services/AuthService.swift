//
//  AuthService.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation

struct RegisterDTO: Encodable {
    let phone, password, email, username, city: String
}

struct LoginDTO: Encodable {
    let identifier: String   // phone or email
    let password: String
}

struct User: Decodable {
    let _id, phone, email, username, city: String
    let avatar: String?
}

struct RegisterResponse: Decodable {
    let phone, email, username, city, _id: String
}

struct LoginResponse: Decodable {
    let user: User
    let accessToken: String
    let refreshToken: String
}

protocol AuthService {
    func register(_ dto: RegisterDTO) async throws -> RegisterResponse
    func login(_ dto: LoginDTO) async throws -> User
    func logout()
}

final class AuthServiceImpl: AuthService {

    private let client = HTTPClient.shared

    func register(_ dto: RegisterDTO) async throws -> RegisterResponse {
        try await client.postJSON(endpoint: "/auth/register", body: dto)
    }

    func login(_ dto: LoginDTO) async throws -> User {
        let resp: LoginResponse = try await client.postJSON(endpoint: "/auth/login", body: dto)
        TokenStore.shared.accessToken = resp.accessToken        // ⭐️ сохраняем
        return resp.user
    }

    func logout() {
        TokenStore.shared.accessToken = nil
    }
}
