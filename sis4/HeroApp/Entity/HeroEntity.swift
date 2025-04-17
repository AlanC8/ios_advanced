import Foundation

struct HeroEntity: Decodable {
    let id: Int
    let name: String
    let powerstats: PowerStats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: Images

    var thumbURL: URL? { URL(string: images.sm) }
    var largeURL: URL? { URL(string: images.lg) }

    struct PowerStats: Decodable { let intelligence, strength, speed, durability, power, combat: Int }
    struct Appearance: Decodable  { let gender: String; let race: String?; let height, weight: [String]; let eyeColor, hairColor: String }
    struct Biography: Decodable   { let fullName: String; let alignment: String; let aliases: [String]; let publisher: String? }
    struct Work: Decodable        { let occupation, base: String }
    struct Connections: Decodable { let groupAffiliation, relatives: String }
    struct Images: Decodable      { let xs, sm, md, lg: String }
}
