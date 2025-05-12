//
//  CarService.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation

protocol CarService {
    func fetch(filter: CarFilter) async throws -> CarListResponse
    func fetchOne(id: String)    async throws -> CarDetail    // ← тип CarDetail
}

final class CarServiceImpl: CarService {
    private let client = HTTPClient.shared

    func fetch(filter: CarFilter) async throws -> CarListResponse {
        try await client.getJSON(endpoint: "cars", query: filter.asQuery())
    }

    func fetchOne(id: String) async throws -> CarDetail {     // ← тип CarDetail
        try await client.getJSON(endpoint: "cars/\(id)")
    }
}
