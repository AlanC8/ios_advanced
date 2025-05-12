//
//  Car.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import SwiftUI

struct CarListResponse: Decodable {
    let total: Int
    let docs: [Car]
}

struct Car: Decodable, Identifiable {
    let id: String
    let brand: String           // id марки
    let series: String          // id серии         ← добавлено
    let generation: String      // id поколения     ← добавлено
    let title: String
    let price: Int
    let currency: String
    let year: Int
    let mileage: Int
    let city: String
    let photos: [String]

    private enum CodingKeys: String, CodingKey {
        case id          = "_id"
        case brand, series, generation
        case title, price, currency, year, mileage, city, photos
    }
}
