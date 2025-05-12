//
//  AddCarDraft.swift
//  final
//
//  Created by Алан Абзалханулы on 12.05.2025.
//

import Foundation

struct AddCarDraft: Encodable {
    // id’ы с правильными названиями
    var brand: String?        // ← было brandID
    var series: String?
    var generation: String?

    // примитивы
    var vin = ""
    var year = 0
    var mileage = 0
    var price = 0
    var currency = "KZT"

    // двигатель
    var engineVolume = 0.0
    var engineType   = "petrol"

    // прочее
    var gearbox = "automatic"
    var drive   = "rwd"
    var steeringSide = "left"
    var customsCleared = true
    var city  = ""
    var title = ""
    var description = ""
    var features: [String] = []
    var photos: [String] = []

    // кастомный encoder — собираем engine-объект
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(brand,       forKey: .brand)
        try c.encodeIfPresent(series,      forKey: .series)
        try c.encodeIfPresent(generation,  forKey: .generation)

        try c.encode(vin,   forKey: .vin)
        try c.encode(year,  forKey: .year)
        try c.encode(mileage, forKey: .mileage)
        try c.encode(price,   forKey: .price)
        try c.encode(currency, forKey: .currency)

        // вложенный engine
        var eng = c.nestedContainer(keyedBy: EngineKeys.self, forKey: .engine)
        try eng.encode(engineVolume, forKey: .volume)
        try eng.encode(engineType,   forKey: .type)

        try c.encode(gearbox, forKey: .gearbox)
        try c.encode(drive,   forKey: .drive)
        try c.encode(steeringSide,   forKey: .steeringSide)
        try c.encode(customsCleared, forKey: .customsCleared)

        try c.encode(city,    forKey: .city)
        try c.encode(title,   forKey: .title)
        try c.encode(description, forKey: .description)
        try c.encode(features,    forKey: .features)
        try c.encode(photos,      forKey: .photos)
    }

    private enum CodingKeys: String, CodingKey {
        case brand, series, generation,
             vin, year, mileage, price, currency,
             engine, gearbox, drive, steeringSide, customsCleared,
             city, title, description, features, photos
    }
    private enum EngineKeys: String, CodingKey { case volume, type }
}



