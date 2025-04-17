import Foundation

struct HeroDetailModel: Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let image: URL?
    let power: [Stat]
    let bio:  [Row]
    let work: [Row]

    struct Stat: Identifiable { let id = UUID(); let title: String; let value: Int }
    struct Row:  Identifiable { let id = UUID(); let title, value: String }
}
