//
//  APIModels.swift
//  weather-app
//
//  Created by Алан Абзалханулы on 11.04.2025.
//

import Foundation


struct Location: Decodable {
    let lat: Double?
    let lon: Double?
    let name: String?
    let type: String?
}

struct TimelineData: Decodable {
    let time: String
    let values: WeatherValues
}

struct WeatherValues: Decodable {
    let temperature: Double?
    let temperatureApparent: Double?
    let humidity: Double?
    let cloudCover: Double?
    let pressureSeaLevel: Double?
    let visibility: Double?
    let windSpeed: Double?
    let windGust: Double?
    let precipitationProbability: Double?
    let epaIndex: Double?
    let particulateMatter25: Double?
    let particulateMatter10: Double?
    let o3: Double?
    let no2: Double?
    let co: Double?
    let so2: Double?
    let fireIndex: Int?
    let floodIndex: Int?
    let stormIndex: Int?
}

struct Timelines: Decodable {
    let minutely: [TimelineData]?
    let hourly:   [TimelineData]?
    let daily:    [TimelineData]?
}

struct ForecastWeatherResponse: Decodable {
    let timelines: Timelines
    let location: Location
}

struct RealtimeWeatherResponse: Decodable {
    let data: TimelineData
    let location: Location
}
