import UIKit

struct Post: Hashable, Equatable {
    let id: UUID
    let authorId: UUID
    var content: String
    var likes: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(authorId)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
} 
