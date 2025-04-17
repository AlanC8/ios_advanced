import Foundation

struct HeroServiceImpl: HeroService {

    private let base = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/"

    func fetchHeroes() async throws -> [HeroEntity] {
        try await request("all.json")
    }

    func fetchHero(id: Int) async throws -> HeroEntity {
        try await request("id/\(id).json")
    }

    private func request<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: base + path) else { throw HeroError.badURL }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch is DecodingError {
            throw HeroError.decoding
        } catch {
            throw HeroError.server
        }
    }
}
