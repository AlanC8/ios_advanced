import Foundation

protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    func fetchHero(id: Int) async throws -> HeroEntity
}

enum HeroError: Error, LocalizedError {
    case badURL, decoding, server

    var errorDescription: String? {
        switch self {
        case .badURL:   "Bad URL"
        case .decoding: "Decoding error"
        case .server:   "Server error"
        }
    }
}
