//
//  AuthService.swift
//  final
//
//  Created by Алан Абзалханулы on 22.04.2025.
//


import Foundation
import UIKit

struct AuthService {
    private let baseURL = URL(string: "http://localhost:8000")!

    struct TokenResponse: Decodable { let access_token: String }

    func register(username: String, email: String, password: String) async throws {
        let body = ["username": username,
                    "email": email,
                    "password": password]

        let _: Empty = try await send(path: "/users/",
                                      method: "POST",
                                      json: body)
    }

    @discardableResult
    func login(username: String, password: String) async throws -> String {
        let body = "username=\(username)&password=\(password)"
            .data(using: .utf8)!
        let token: TokenResponse = try await send(path: "/users/token",
                                                  method: "POST",
                                                  body: body,
                                                  contentType: "application/x-www-form-urlencoded")
        return token.access_token
    }

    @discardableResult
    private func send<T: Decodable>(path: String,
                                    method: String,
                                    json: [String: Any]? = nil,
                                    body: Data? = nil,
                                    contentType: String = "application/json") async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = method
        if let json {
            req.httpBody = try JSONSerialization.data(withJSONObject: json)
        } else if let body {
            req.httpBody = body
        }
        req.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        if T.self == Empty.self { return Empty() as! T }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private struct Empty: Decodable {}
}
