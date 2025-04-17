import Foundation

struct Hero: Decodable {
    let id: Int
    let name: String
    let slug: String
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let images: Image
    
    var imageUrl: URL? {
        URL(string: images.md)
    }
    
    struct Powerstats: Decodable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }
    
    struct Appearance: Decodable {
        let gender: String
        let race: String?
        let height: [String]
        let weight: [String]
    }
    
    struct Biography: Decodable {
        let fullName: String
        let alterEgos: String
        let placeOfBirth: String
        let publisher: String?
    }
    
    struct Work: Decodable {
        let occupation: String
        let base: String
    }
    
    struct Image: Decodable {
        let md: String
    }
}

final class ViewModel: ObservableObject {
    @Published var selectedHero: Hero?

    func fetchHero() async {
        guard
            let url = URL(string: "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json")
        else {
            return
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let heroes = try JSONDecoder().decode([Hero].self, from: data)
            let randomHero = heroes.randomElement()

            await MainActor.run {
                selectedHero = randomHero
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
}
