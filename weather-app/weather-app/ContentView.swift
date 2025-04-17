//
//  ContentView.swift
//  weather-app
//
//  Created by Алан Абзалханулы on 10.04.2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var cityVM: CityViewModel
    @StateObject private var weatherVM: WeatherViewModel
    @State private var showPicker = false
    
    init() {
        let city = CityViewModel()
        _cityVM = StateObject(wrappedValue: city)
        _weatherVM = StateObject(wrappedValue: WeatherViewModel(cityVM: city))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.5), .white],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack {
                    header
                    if weatherVM.isLoading {
                        ProgressView().scaleEffect(1.5).padding(.top, 50)
                    } else if let err = weatherVM.error {
                        ErrorView(message: err)
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                if let cw = weatherVM.currentWeather { CurrentWeatherCard(weather: cw) }
                                if !weatherVM.hourly.isEmpty     { ForecastCard(forecast: weatherVM.hourly) }
                                if !weatherVM.fiveDay.isEmpty    { FiveDayForecastCard(forecast: weatherVM.fiveDay) }
                                if let aq = weatherVM.airQuality { AirQualityCard(airQuality: aq) }
                                if !weatherVM.alerts.isEmpty     { AlertsCard(alerts: weatherVM.alerts) }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Погода")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { Task { await weatherVM.reload() } }
                    label: { Image(systemName: "arrow.clockwise") }
                }
            }
            .sheet(isPresented: $showPicker) {
                CitySelectionView(selectedCity: $cityVM.selectedCity)
                    .presentationDetents([.fraction(0.5), .large])
            }
            .task { await weatherVM.reload() }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cityVM.selectedCity?.name ?? "")
                    .font(.title).bold()
                Text(cityVM.selectedCity?.country ?? "")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button { showPicker = true } label: {
                Label("Город", systemImage: "location.circle.fill")
                    .padding(8).background(.blue.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal)
    }
}


struct ErrorView: View {
    let message: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle).foregroundColor(.red)
            Text(message).multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct CurrentWeatherCard: View {
    let weather: WeatherData
    var body: some View {
        card {
            VStack(spacing: 16) {
                Text("Сейчас").font(.title2).bold()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Int(weather.temperature))°").font(.system(size: 60).bold())
                        Text(weather.description).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "cloud.sun.fill").font(.system(size: 60)).foregroundStyle(.yellow, .gray)
                }
                Text("Обновлено: \(weather.time)").font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

struct ForecastCard: View {
    let forecast: [HourlyWeatherData]
    private let iso = ISO8601DateFormatter()
    var body: some View {
        card {
            VStack(alignment: .leading) {
                Text("Ближайшие часы").font(.title2).bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(forecast, id: \.time) { h in
                            VStack {
                                Text(time(h.time))
                                Image(systemName: "cloud.sun")
                                Text("\(Int(h.temperature))°").bold()
                                Text("\(Int(h.humidity))%").font(.caption).foregroundColor(.blue)
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        }
                    }
                }
            }
        }
    }
    private func time(_ s: String) -> String {
        (iso.date(from: s).map { DateFormatter.localizedString(from: $0, dateStyle: .none, timeStyle: .short) }) ?? s
    }
}

struct FiveDayForecastCard: View {
    let forecast: [[HourlyWeatherData]]
    private let iso = ISO8601DateFormatter()
    var body: some View {
        card {
            VStack(alignment: .leading) {
                Text("5‑дневный прогноз").font(.title2).bold()
                ForEach(0..<forecast.count, id: \.self) { idx in
                    if let first = forecast[idx].first {
                        Text(date(first.time)).font(.headline).padding(.top, 4)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(forecast[idx], id: \.time) { h in
                                VStack {
                                    Text(time(h.time)).font(.caption)
                                    Image(systemName: "cloud.sun")
                                    Text("\(Int(h.temperature))°").bold().font(.subheadline)
                                }
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.7)))
                            }
                        }
                    }
                    if idx < forecast.count - 1 { Divider() }
                }
            }
        }
    }
    private func date(_ s: String) -> String {
        guard let d = iso.date(from: s) else { return s }
        let f = DateFormatter(); f.locale = .current; f.dateFormat = "EEEE, d MMM"
        return f.string(from: d).capitalized
    }
    private func time(_ s: String) -> String {
        guard let d = iso.date(from: s) else { return s }
        return DateFormatter.localizedString(from: d, dateStyle: .none, timeStyle: .short)
    }
}

struct AirQualityCard: View {
    let airQuality: AirQualityData
    var body: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Качество воздуха").font(.title2).bold()
                HStack {
                    VStack(alignment: .leading) {
                        Text("AQI: \(airQuality.aqi)").font(.title3)
                        Text(airQuality.description).foregroundColor(color(airQuality.aqi))
                    }
                    Spacer()
                    Image(systemName: "aqi.high").font(.system(size: 40)).foregroundColor(color(airQuality.aqi))
                }
                Divider()
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 6) {
                    ForEach(airQuality.components.sorted(by: { $0.key < $1.key }), id: \.key) { k, v in
                        HStack { Text(k); Spacer(); Text(String(format: "%.1f", v)).bold() }
                    }
                }
            }
        }
    }
    private func color(_ aqi: Int) -> Color {
        switch aqi {
        case 1: return .green; case 2: return .green.opacity(0.8)
        case 3: return .yellow; case 4: return .orange
        case 5: return .red;   default: return .gray
        }
    }
}

struct AlertsCard: View {
    let alerts: [WeatherAlert]
    var body: some View {
        card {
            VStack(alignment: .leading, spacing: 8) {
                Text("Предупреждения").font(.title2).bold()
                ForEach(alerts, id: \.title) { a in AlertRow(alert: a) }
            }
        }
    }
}

struct AlertRow: View {
    let alert: WeatherAlert
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                Text(alert.title).bold()
                Spacer()
                Text(alert.severity).font(.caption)
                    .padding(4).background(color(alert.severity))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .foregroundColor(.white)
            }
            Text(alert.description).font(.subheadline).foregroundColor(.secondary)
            Text("Время: \(alert.time)").font(.caption2).foregroundColor(.secondary)
            Divider()
        }
    }
    private func color(_ s: String) -> Color {
        switch s.lowercased() {
        case "высокая": return .red
        case "средняя": return .orange
        default:        return .yellow
        }
    }
}


struct CitySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCity: City?
    @State private var search = ""
    var body: some View {
        NavigationStack {
            List(filtered) { city in
                Button {
                    selectedCity = city; dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(city.name).font(.headline)
                            Text(city.country).foregroundColor(.secondary)
                        }
                        Spacer()
                        if city == selectedCity { Image(systemName: "checkmark").foregroundColor(.blue) }
                    }
                }
            }
            .searchable(text: $search, prompt: "Поиск")
            .navigationTitle("Выбор города")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } } }
        }
    }
    private var filtered: [City] {
        guard !search.isEmpty else { return City.presetCities }
        let s = search.lowercased()
        return City.presetCities.filter { $0.name.lowercased().contains(s) || $0.country.lowercased().contains(s) }
    }
}


@ViewBuilder
private func card<Content:View>(@ViewBuilder _ c: () -> Content) -> some View {
    c()
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(radius: 5))
        .padding(.horizontal)
}


#Preview {
    ContentView()
}
