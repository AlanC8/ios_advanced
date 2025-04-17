import UIKit

struct FeedItem {
    let post: Post
    let author: UserProfile
    var isLiked: Bool = false

    var formattedLikes: String {
        return post.likes > 1000 ? "\(post.likes/1000)K" : "\(post.likes)"
    }
} 
