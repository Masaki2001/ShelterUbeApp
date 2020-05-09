
import UIKit

class ShelterTableViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    var tableView: UITableView!
    lazy var shelters: [Shelter] = Shelter.list
    var searchBarButtonItem: UIBarButtonItem!
    var selectBarButtonItem: UIBarButtonItem!
    var searchBar: UISearchBar!
    var sortConditions: [ConditionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "避難所一覧"
        self.navigationController?.delegate = self
        
        setSearchBarButtonItem()
        setTableView()
    }
    
    // MARK: SetUp
    
    private func setTableView() {
        tableView = UITableView()
        tableView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.maxX,
            height: self.view.frame.maxY
        )
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setSearchBarButtonItem() {
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        searchBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchButtonAction)
        )
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        let selectBarButtonImage = UIImage(systemName: "line.horizontal.3.decrease.circle", withConfiguration: configuration)
        selectBarButtonItem = UIBarButtonItem(
            image: selectBarButtonImage,
            style: .plain,
            target: self,
            action: #selector(selectConditionAction)
        )
        self.navigationItem.rightBarButtonItems = [
            space,
            searchBarButtonItem,
            selectBarButtonItem
        ]
    }
    
    private func setSearchBar() {
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            searchBar = UISearchBar(frame: navigationBarFrame)
            navigationItem.titleView?.frame = searchBar.frame
            searchBar.showsCancelButton = true
            searchBar.delegate = self
            showSearchBar()
            
            navigationItem.titleView = searchBar
        }
    }
    
    // MARK: Private Action
    
    private func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems?.removeAll()
        self.searchBar.becomeFirstResponder()
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.searchBar.alpha = 1
        })
    }
    
    private func hideSearchBar() {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.navigationItem.titleView?.alpha = 0
                self.setSearchBarButtonItem()
        },
            completion: { finished in
                self.navigationItem.titleView = nil
        })
    }
    
    private func setSelectBarButtonImage() {
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        let filterImage = UIImage(systemName: "line.horizontal.3.decrease.circle", withConfiguration: configuration)
        let filterFillImage = UIImage(systemName: "line.horizontal.3.decrease.circle.fill", withConfiguration: configuration)
        selectBarButtonItem.image = sortConditions.isEmpty ? filterImage : filterFillImage
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let showViewController = ShowShelterViewController(shelter: shelters[indexPath.row])
        self.navigationController?.pushViewController(showViewController, animated: true)
    }
    
    // MARK: ItemButton Action
    @objc func searchButtonAction() {
        setSearchBar()
    }
    
    @objc func selectConditionAction() {
        let selectConditionViewController = SelectConditionTableViewController()
        selectConditionViewController.sortConditions = sortConditions
        present(selectConditionViewController, animated: true, completion: nil)
    }
}

extension ShelterTableViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shelters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShelterTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = shelters[indexPath.row].name
        cell.detailTextLabel?.text = shelters[indexPath.row].address
        
        return cell
    }
}

extension ShelterTableViewController: UISearchBarDelegate {
    
    // MARK: UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        loadList()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadList()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.isFirstResponder
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        loadList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
        searchBar.text = ""
        loadList()
    }
    
    // MARK: Action
    
    func loadList() {
        
        var list: [Shelter]!
        
        if let searchBar = searchBar {
            if (searchBar.text ?? "").isEmpty {
                list = Shelter.list
            } else {
                list = Shelter.list.filter { $0.name.contains(searchBar.text!) }
            }
        } else {
            list = Shelter.list
        }
        
        shelters = Shelter.whereShelter(list: list, conditions: sortConditions)
        tableView.reloadData()
        
        setSelectBarButtonImage()
    }
}
