import UIKit

struct Item {
    let id: Int
    let name: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var dataSource = [Item]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    private var searchDataSource: [Item]? {
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
        
        var items = [Item]()
        items.append(Item(id: 1, name: "Java"))
        items.append(Item(id: 2, name: "JavaScript"))
        items.append(Item(id: 3, name: "C++"))
        items.append(Item(id: 4, name: "Go"))
        items.append(Item(id: 5, name: "SQL"))
        items.append(Item(id: 6, name: "Kotlin"))
        items.append(Item(id: 7, name: "PHP"))
        items.append(Item(id: 8, name: "Python"))
        items.append(Item(id: 9, name: "Erlang"))
        items.append(Item(id: 10, name: "Scheme"))
        items.append(Item(id: 11, name: "Swift"))
        items.append(Item(id: 12, name: "R"))
        items.append(Item(id: 13, name: "Ruby"))
        items.append(Item(id: 14, name: "Elixir"))
        items.append(Item(id: 15, name: "Haskell"))
        items.append(Item(id: 16, name: "Scala"))
        items.append(Item(id: 17, name: "TypeScript"))
        items.append(Item(id: 18, name: "C#"))
        items.append(Item(id: 19, name: "Perl"))
        items.append(Item(id: 20, name: "Rust"))
        self.dataSource = items
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
        let item = self.searchDataSource?[indexPath.row] ?? self.dataSource[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
     func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
         searchBar.showsCancelButton = true
         return true
     }
    
     func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
         searchBar.showsCancelButton = false
         return true
     }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // quit if the new searchText is same as old searchTerm
        guard (self.searchTerm.caseInsensitiveCompare(searchText) != ComparisonResult.orderedSame) else { return }
        
        self.searchTerm = searchText
        
        if searchText.isEmpty {
            self.searchDataSource = nil
        } else {
            self.searchDataSource = self.dataSource.filter({
                return $0.name.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil
            })
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? true && self.searchDataSource != nil) {
            self.searchDataSource = nil
        }
    }
    
}
