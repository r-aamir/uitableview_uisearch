import UIKit

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var dataSource = [User]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    private var searchDataSource: [User]? {
        didSet {
            self.tableview.reloadData()
        }
    }
    private var searchTerm = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        self.searchBar.delegate = self
        
        let url = URL(string: "https://example.org/users.php")
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "An error occurred")
                return
            }
            
            DispatchQueue.main.async {
                self?.dataSource = try! JSONDecoder().decode([User].self, from: data)
            }
        }).resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchDataSource?.count ?? self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        let user = self.searchDataSource?[indexPath.row] ?? self.dataSource[indexPath.row]
        cell.textLabel?.text = user.firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.searchDataSource?[indexPath.row] ?? self.dataSource[indexPath.row]
        let userVC = UserViewController(user: user)
        self.navigationController?.pushViewController(userVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //     searchBar.showsCancelButton = true
    //     return true
    // }
    
    // func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    //     searchBar.showsCancelButton = false
    //     return true
    // }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // quit if the new searchText is same as old searchTerm
        guard (self.searchTerm.caseInsensitiveCompare(searchText) != ComparisonResult.orderedSame) else { return }
        
        self.searchTerm = searchText
        
        if searchText.isEmpty {
            self.searchDataSource = nil
        } else {
            self.searchDataSource = self.dataSource.filter({
                let fullName = $0.firstName + " " + $0.lastName
                return fullName.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil
            })
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? true && self.searchDataSource != nil) {
            self.searchDataSource = nil
        }
    }
    
}
