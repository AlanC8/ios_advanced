import Combine
import Foundation

@MainActor
final class HeroListViewModel: ObservableObject {
    @Published var searchText = ""

    @Published private(set) var heroes: [HeroListModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?

    private let service: HeroService
    private let router:  HeroRouter
    private var all: [HeroListModel] = []
    private var bag = Set<AnyCancellable>()

    init(service: HeroService, router: HeroRouter) {
        self.service = service
        self.router  = router

        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] term in self?.filter(term) }
            .store(in: &bag)
    }

    func fetchHeroes() async {
        isLoading = true; error = nil
        do {
            let list = try await service.fetchHeroes()
            all = list.map(Self.map)
            heroes = all
        } catch let err { error = err.localizedDescription }
        isLoading = false
    }

    func routeToDetail(by id: Int) { router.showDetails(for: id) }

    private static func map(_ e: HeroEntity) -> HeroListModel {
        HeroListModel(
            id: e.id,
            title: e.name,
            subtitle: e.biography.fullName.isEmpty ? (e.appearance.race ?? "Unknown race") : e.biography.fullName,
            image: e.thumbURL,
            publisher: e.biography.publisher ?? "Unknown")
    }

    private func filter(_ term: String) {
        heroes = term.isEmpty
            ? all
            : all.filter { $0.title.lowercased().contains(term.lowercased()) }
    }
}

