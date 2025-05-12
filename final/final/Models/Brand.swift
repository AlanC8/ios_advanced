//
//  Brand.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//
import Foundation


struct Series: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let generations: [Generation]
    private enum CodingKeys: String, CodingKey { case id = "_id", name, generations }

    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Generation: Decodable, Identifiable, Hashable {
    let id: String
    let code: String
    private enum CodingKeys: String, CodingKey { case id = "_id", code }

    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
