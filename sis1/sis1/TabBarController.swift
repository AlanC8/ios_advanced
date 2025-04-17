import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 0)
        
        let hobbiesVC = HobbiesViewController()
        hobbiesVC.tabBarItem = UITabBarItem(title: "Хобби", image: UIImage(systemName: "heart"), tag: 1)
        
        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(title: "Цели", image: UIImage(systemName: "star"), tag: 2)
        
        viewControllers = [
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: hobbiesVC),
            UINavigationController(rootViewController: goalsVC)
        ]
    }
} 