//
//  BrandService.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct Brand: Decodable, Identifiable {
    let id: String
    let name: String
    private enum CodingKeys: String, CodingKey { case id = "_id", name }
}

protocol BrandService {
    func fetchBrands() async throws -> [Brand]
    func fetchSeries(for brandID: String) async throws -> [Series]
}

final class BrandServiceImpl: BrandService {
    private let client = HTTPClient.shared

    func fetchBrands() async throws -> [Brand] {
        try await client.getJSON(endpoint: "brands")
    }

    func fetchSeries(for brandID: String) async throws -> [Series] {
        struct BrandDetail: Decodable { let series: [Series] }
        let detail: BrandDetail = try await client.getJSON(endpoint: "brands/\(brandID)")
        return detail.series
    }
}
