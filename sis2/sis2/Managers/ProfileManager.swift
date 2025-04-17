import UIKit

class ProfileManager {
    private var activeProfiles: [String: UserProfile] = [:]
    
    weak var delegate: ProfileUpdateDelegate?
    
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate) {
        self.delegate = delegate
    }
    
    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let profile = UserProfile(id: UUID(), 
                                   username: "user_\(id)", 
                                   bio: "Bio for user \(id)", 
                                   followers: 0)
            
            DispatchQueue.main.async {
                self.activeProfiles[id] = profile
                self.delegate?.profileDidUpdate(profile)
                completion(.success(profile))
            }
        }
    }
} 
