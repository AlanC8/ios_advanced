import Foundation

class TomorrowWeatherService {
    private let apiKey  = "m9MXis8clDzrlJv1F40SYQApYAVCDlfm"
    private let rootURL = "https://api.tomorrow.io/v4"
    private let session = URLSession.shared


    func getCurrentWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let url = try buildURL(path: "/weather/realtime",
                               location: "\(lat),\(lon)",
                               fields: ["temperature","cloudCover","humidity"])
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(RealtimeWeatherResponse.self, from: data)

        return WeatherData(
            temperature: decoded.data.values.temperature ?? .nan,
            description: "Облачность: \(decoded.data.values.cloudCover ?? 0)%",
            time: decoded.data.time
        )
    }

    func getHourlyForecast(lat: Double, lon: Double) async throws -> [HourlyWeatherData] {
        let url = try buildURL(path: "/weather/forecast",
                               location: "\(lat),\(lon)",
                               fields: ["temperature","humidity"],
                               timesteps: "1h")
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(ForecastWeatherResponse.self, from: data)

        return decoded.timelines.hourly?.map {
            HourlyWeatherData(
                time: $0.time,
                temperature: $0.values.temperature ?? .nan,
                humidity: $0.values.humidity ?? .nan
            )
        } ?? []
    }

    func getFiveDayForecast(lat: Double, lon: Double) async throws -> [[HourlyWeatherData]] {
        let start = ISO8601DateFormatter().string(from: Date())
        let end   = ISO8601DateFormatter().string(
            from: Calendar.current.date(byAdding: .day, value: 5, to: .init())!
        )

        let url = try buildURL(path: "/weather/forecast",
                               location: "\(lat),\(lon)",
                               fields: ["temperature","humidity"],
                               timesteps: "1h",
                               startTime: start,
                               endTime: end)

        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(ForecastWeatherResponse.self, from: data)
        guard let hours = decoded.timelines.hourly else { return [] }

        var dict: [Date:[HourlyWeatherData]] = [:]
        let iso  = ISO8601DateFormatter()
        for h in hours {
            guard let date = iso.date(from: h.time) else { continue }
            let day = Calendar.current.startOfDay(for: date)
            dict[day, default: []].append(
                HourlyWeatherData(time: h.time,
                                  temperature: h.values.temperature ?? .nan,
                                  humidity: h.values.humidity ?? .nan)
            )
        }
        return dict.keys.sorted().map { dict[$0]!.sorted { $0.time < $1.time } }
    }

    func fetchAirQuality(lat: Double, lon: Double) async throws -> AirQualityData {
        let url = try buildURL(path: "/weather/realtime",
                               location: "\(lat),\(lon)",
                               fields: ["epaIndex","particulateMatter25","particulateMatter10","o3","no2","co","so2"])
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(RealtimeWeatherResponse.self, from: data)
        let vals = decoded.data.values

        let aqi = Int(vals.epaIndex ?? 1)
        var comps: [String:Double] = [:]
        if let v = vals.particulateMatter25 { comps["PM2.5"] = v }
        if let v = vals.particulateMatter10 { comps["PM10"] = v }
        if let v = vals.o3   { comps["O3"]  = v }
        if let v = vals.no2  { comps["NO2"] = v }
        if let v = vals.co   { comps["CO"]  = v }
        if let v = vals.so2  { comps["SO2"] = v }

        return AirQualityData(
            aqi: aqi,
            description: airQualityDescription(epaIndex: aqi),
            components: comps
        )
    }

    func fetchWeatherAlerts(lat: Double, lon: Double) async throws -> [WeatherAlert] {
        let url = try buildURL(path: "/weather/realtime",
                               location: "\(lat),\(lon)",
                               fields: ["fireIndex","floodIndex","stormIndex"])
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(RealtimeWeatherResponse.self, from: data)
        let v = decoded.data.values
        var arr: [WeatherAlert] = []

        if let f = v.fireIndex, f > 2 { arr.append(alert(name: "Пожарная опасность", level: f, time: decoded.data.time)) }
        if let f = v.floodIndex, f > 2 { arr.append(alert(name: "Риск наводнения",   level: f, time: decoded.data.time)) }
        if let s = v.stormIndex, s > 2 { arr.append(alert(name: "Штормовое предупреждение", level: s, time: decoded.data.time)) }

        return arr
    }


    private func buildURL(path: String,
                          location: String,
                          fields: [String],
                          timesteps: String? = nil,
                          startTime: String? = nil,
                          endTime: String? = nil,
                          units: String = "metric") throws -> URL {

        var comps = URLComponents(string: rootURL + path)!
        var items = [
            URLQueryItem(name: "apikey",   value: apiKey),
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "fields",   value: fields.joined(separator: ",")),
            URLQueryItem(name: "units",    value: units)
        ]
        if let t = timesteps  { items.append(.init(name: "timesteps", value: t)) }
        if let s = startTime  { items.append(.init(name: "startTime", value: s)) }
        if let e = endTime    { items.append(.init(name: "endTime",   value: e)) }

        comps.queryItems = items
        guard let url = comps.url else { throw URLError(.badURL) }
        return url
    }

    private func airQualityDescription(epaIndex: Int) -> String {
        switch epaIndex {
        case 1: return "Отличное"
        case 2: return "Хорошее"
        case 3: return "Среднее"
        case 4: return "Плохое"
        case 5: return "Очень плохое"
        default: return "Неизвестно"
        }
    }

    private func alert(name: String, level: Int, time: String) -> WeatherAlert {
        WeatherAlert(title: name,
                     description: "\(name) (уровень \(level)/5)",
                     severity: level > 3 ? "Высокая" : "Средняя",
                     time: time)
    }
}
