import UIKit

class FeedSystem {
    private var userCache: [UUID: UserProfile] = [:]
    
    private var feedPosts: [Post] = []
    
    private var hashtags: Set<String> = []
    
    func addPost(_ post: Post) {
        feedPosts.insert(post, at: 0)
        
        let newHashtags = extractHashtags(from: post.content)
        hashtags.formUnion(newHashtags)
    }
    
    func removePost(_ post: Post) {
        if let index = feedPosts.firstIndex(of: post) {
            feedPosts.remove(at: index)
        }
    }
    
    private func extractHashtags(from content: String) -> Set<String> {
        let words = content.components(separatedBy: .whitespacesAndNewlines)
        return Set(words.filter { $0.hasPrefix("#") })
    }
}  
