import UIKit

class HobbiesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(HobbyCell.self, forCellReuseIdentifier: "HobbyCell")
        return table
    }()
    
    private let hobbies: [(title: String, description: String, image: String)] = [
        ("Хобби 1", "Описание хобби 1", "hobby1"),
        ("Хобби 2", "Описание хобби 2", "hobby2"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Хобби"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HobbiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HobbyCell", for: indexPath) as! HobbyCell
        let hobby = hobbies[indexPath.row]
        cell.configure(title: hobby.title, description: hobby.description, imageName: hobby.image)
        return cell
    }
} 
