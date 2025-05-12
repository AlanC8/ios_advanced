//
//  AddCarService.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//
import Foundation

protocol AddCarService { func create(_ draft: AddCarDraft) async throws }
final class AddCarServiceImpl: AddCarService {
    private let client = HTTPClient.shared
    func create(_ draft: AddCarDraft) async throws {
        try await client.postJSON(endpoint: "cars", body: draft) as EmptyCodable
    }
}
private struct EmptyCodable: Codable {}
