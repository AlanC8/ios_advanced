//
//  CarDetail.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//

import Foundation

struct CarDetail: Decodable {
    let id: String
    let title: String
    let price: Int
    let currency: String
    let year: Int
    let mileage: Int
    let city: String
    let engine: Engine
    let gearbox: String
    let drive: String
    let description: String
    let photos: [String]

    struct Engine: Decodable {
        let volume: Double
        let type: String
    }

    private enum CodingKeys: String, CodingKey {
        case id = "_id", title, price, currency, year, mileage, city, engine, gearbox, drive, description, photos
    }
}
