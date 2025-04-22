import Foundation

@MainActor
final class HeroDetailViewModel: ObservableObject {

    @Published private(set) var model: HeroDetailModel?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?

    private let heroId: Int
    private let service: HeroService

    init(heroId: Int, service: HeroService) {
        self.heroId  = heroId
        self.service = service
    }

    func load() async {
        isLoading = true; error = nil
        do {
            let e = try await service.fetchHero(id: heroId)
            model = Self.map(e)
            isLoading = false
        } catch let err { error = err.localizedDescription }
    }

    private static func map(_ e: HeroEntity) -> HeroDetailModel {
        HeroDetailModel(
            id: e.id,
            name: e.name,
            fullName: e.biography.fullName,
            image: e.largeURL,
            power: [
                .init(title: "Intelligence", value: e.powerstats.intelligence),
                .init(title: "Strength",     value: e.powerstats.strength),
                .init(title: "Speed",        value: e.powerstats.speed),
                .init(title: "Durability",   value: e.powerstats.durability),
                .init(title: "Power",        value: e.powerstats.power),
                .init(title: "Combat",       value: e.powerstats.combat)
            ],
            bio: [
                .init(title: "Aliases",  value: e.biography.aliases.joined(separator: ", ")),
                .init(title: "Alignment",value: e.biography.alignment),
                .init(title: "Publisher",value: e.biography.publisher ?? "-")
            ],
            work: [
                .init(title: "Occupation", value: e.work.occupation),
                .init(title: "Base",       value: e.work.base)
            ])
    }
}
