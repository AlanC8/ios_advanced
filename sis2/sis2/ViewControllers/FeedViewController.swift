import UIKit

class FeedViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var feedItems: [FeedItem] = []
    private let feedSystem = FeedSystem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadMockData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )
    }
    
    private func loadMockData() {
        let mockPosts = [
            Post(id: UUID(), authorId: UUID(), content: "Enjoying a beautiful sunset! 🌅 #nature #peace", likes: 1234),
            Post(id: UUID(), authorId: UUID(), content: "Just finished my morning workout 💪 #fitness #motivation", likes: 856),
            Post(id: UUID(), authorId: UUID(), content: "New recipe I tried today! 🍳 #cooking #foodie", likes: 2431),
            Post(id: UUID(), authorId: UUID(), content: "Weekend vibes with friends 🎉 #weekend #friends", likes: 1678)
        ]
        
        let mockUsers = [
            UserProfile(id: UUID(), username: "nature_lover", bio: "Living life to the fullest", followers: 1200),
            UserProfile(id: UUID(), username: "fitness_guru", bio: "Personal trainer & lifestyle coach", followers: 5600),
            UserProfile(id: UUID(), username: "chef_mike", bio: "Cooking is my passion", followers: 3400),
            UserProfile(id: UUID(), username: "adventure_time", bio: "Travel | Photography | Life", followers: 2800)
        ]
        
        feedItems = zip(mockPosts, mockUsers).map { post, user in
            FeedItem(post: post, author: user)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func profileTapped() {
        let profileVC = UserProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemCell.identifier, for: indexPath) as? FeedItemCell else {
            return UITableViewCell()
        }
        
        let feedItem = feedItems[indexPath.row]
        cell.configure(with: feedItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension + 175
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 750
    }
}
