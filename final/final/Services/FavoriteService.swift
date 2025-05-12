//
//  FavoriteService.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

protocol FavoriteService { func toggle(carID: String) async throws }

final class FavoriteServiceImpl: FavoriteService {
    func toggle(carID: String) async throws {
        _ = try await HTTPClient.shared.postJSON(
            endpoint: "cars/\(carID)/favorite",
            body: EmptyCodable()
        ) as EmptyCodable
    }
}
private struct EmptyCodable: Codable {}
