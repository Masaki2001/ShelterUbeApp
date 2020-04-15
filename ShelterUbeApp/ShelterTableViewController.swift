
import UIKit

class ShelterTableViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    var tableView: UITableView!
    lazy var shelters: [Shelter] = Shelter.list
    var searchBarButtonItem: UIBarButtonItem!
    var selectBarButtonItem: UIBarButtonItem!
    var searchBar: UISearchBar!
    var sortCondition: ConditionType = .none
    
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
        selectBarButtonItem = UIBarButtonItem(
            title:  selectItemButtonText(),
            style: .done,
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
    
    private func selectItemButtonText() -> String {
            switch sortCondition {
                case .none:
                    return "条件"
                case .emergencyEvacuationSite:
                    return "緊急避難所"
                case .evacuationSite:
                    return "避難所"
                case .caseOfEarthquake:
                    return "地震"
                case .caseOfTsunami:
                    return "津波"
                case .caseOfSedimentDisaster:
                    return "土砂災害"
                case .caseOfHighWavesIn100:
                    return "高潮 100"
                case .caseOfHighWavesIn500:
                    return "高潮 500"
                case .caseOfFlood:
                    return "洪水"
            }
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
        selectConditionViewController.sortCondition = sortCondition
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
        
            switch sortCondition {
                case .none:
                    break
                case .emergencyEvacuationSite:
                    list = list.filter { $0.emergencyEvacuationSite }
                case .evacuationSite:
                    list = list.filter { $0.evacuationSite }
                case .caseOfEarthquake:
                    list = list.filter { $0.caseOfEarthquake }
                case .caseOfTsunami:
                    list = list.filter { $0.caseOfTsunami }
                case .caseOfSedimentDisaster:
                    list = list.filter { $0.caseOfSedimentDisaster }
                case .caseOfHighWavesIn100:
                    list = list.filter { $0.caseOfHighWavesIn100 }
                case .caseOfHighWavesIn500:
                    list = list.filter { $0.caseOfHighWavesIn500 }
                case .caseOfFlood:
                    list = list.filter { $0.caseOfFlood }
            }

        shelters = list
        tableView.reloadData()
        
        selectBarButtonItem.title = selectItemButtonText()
    }
}
