//
//  WeatherData.swift
//  weather-app
//
//  Created by Алан Абзалханулы on 11.04.2025.
//


import Foundation
import SwiftUI

struct WeatherData {
    let temperature: Double
    let description: String
    let time: String
}

struct HourlyWeatherData {
    let time: String
    let temperature: Double
    let humidity: Double
}

struct WeatherAlert {
    let title: String
    let description: String
    let severity: String
    let time: String
}

struct AirQualityData {
    let aqi: Int
    let description: String
    let components: [String: Double]
}


struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(name); hasher.combine(country)
    }
    static func == (l: City, r: City) -> Bool { l.name == r.name && l.country == r.country }

    static let presetCities = [
        City(name: "Алматы",          country: "Казахстан",  latitude: 43.2220, longitude: 76.8512),
        City(name: "Москва",          country: "Россия",     latitude: 55.7558, longitude: 37.6173),
        City(name: "Санкт‑Петербург", country: "Россия",     latitude: 59.9343, longitude: 30.3351),
        City(name: "Нью‑Йорк",        country: "США",        latitude: 40.7128, longitude: -74.0060),
        City(name: "Лондон",          country: "Великобрит.",latitude: 51.5074, longitude:  -0.1278),
        City(name: "Токио",           country: "Япония",     latitude: 35.6762, longitude: 139.6503)
    ]
}
