//
//  TomorrowWeatherViewModel.swift
//  weather-app
//
//  Created by Алан Абзалханулы on 11.04.2025.

import SwiftUI

@MainActor
final class CityViewModel: ObservableObject {
    @Published var selectedCity: City? = City.presetCities.first
}

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var hourly:  [HourlyWeatherData] = []
    @Published var fiveDay: [[HourlyWeatherData]] = []
    @Published var airQuality: AirQualityData?
    @Published var alerts: [WeatherAlert] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service = TomorrowWeatherService()
    private let cityVM: CityViewModel

    init(cityVM: CityViewModel) { self.cityVM = cityVM }

    func reload() async {
        guard let city = cityVM.selectedCity else { return }
        isLoading = true; defer { isLoading = false }
        do {
            async let w = service.getCurrentWeather(lat: city.latitude, lon: city.longitude)
            async let h = service.getHourlyForecast(lat: city.latitude, lon: city.longitude)
            async let f = service.getFiveDayForecast(lat: city.latitude, lon: city.longitude)
            async let a = service.fetchAirQuality(lat: city.latitude, lon: city.longitude)
            async let al = service.fetchWeatherAlerts(lat: city.latitude, lon: city.longitude)

            currentWeather = try await w
            hourly        = try await h
            fiveDay       = try await f
            airQuality    = try await a
            alerts        = try await al
            error = nil
        } catch {
            self.error = error.localizedDescription
            print("Weather error:", error)
        }
    }
}
