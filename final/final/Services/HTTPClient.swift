//
//  HTTPClient.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation

final class HTTPClient {
    
    static let shared = HTTPClient()
    private init() {}
    
    private let baseURL = URL(string: "http://localhost:3001/")!
    private let session = URLSession(configuration: .default)
    
    // generic JSON POST
    func postJSON<T: Encodable, R: Decodable>(
        endpoint: String,
        body: T
    ) async throws -> R {
        let url = baseURL
            .appendingPathComponent("api/v1")
            .appendingPathComponent(endpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JWT — если есть
        if let token = TokenStore.shared.accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        // Проверяем код ответа
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }
        guard 200..<300 ~= http.statusCode else {
            throw NetworkError.server(status: http.statusCode)
        }
        
        // Декодируем JSON
        do {
            return try JSONDecoder().decode(R.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    func getJSON<R: Decodable>(
        endpoint: String,
        query: [String: String] = [:]
    ) async throws -> R {

        // 1. Базовый URL без двойных «//»
        let base = baseURL.appendingPathComponent("api/v1")
        var comp  = URLComponents(
            string: base.appendingPathComponent(endpoint).absoluteString
        )!
        // 2. Query items
        if !query.isEmpty {
            comp.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = comp.url else { throw NetworkError.badURL }

        // 3. GET-request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = TokenStore.shared.accessToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.server(status: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder().decode(R.self, from: data)
    }
}
