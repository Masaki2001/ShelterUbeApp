
import UIKit

class SelectConditionTableViewController: UIViewController {
    
    // MARK: Properties
    var toolbar: UIToolbar!
    var sortConditions: [ConditionType] = []
    let choiceseList = [
        ["緊急避難場所", ConditionType.emergencyEvacuationSite],
        ["避難場所", ConditionType.evacuationSite],
        ["地震対応", ConditionType.caseOfEarthquake],
        ["津波対応", ConditionType.caseOfTsunami],
        ["土砂災害対応", ConditionType.caseOfSedimentDisaster],
        ["高潮対応 100年に一度", ConditionType.caseOfHighWavesIn100],
        ["高潮対応 500年に一度", ConditionType.caseOfHighWavesIn500],
        ["洪水対応", ConditionType.caseOfFlood]
    ]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setToolbar()
        setTableView()
    }
    
    // MARK: SetUp
    
    private func setToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelItem, space, doneItem], animated: true)
        
        let titleLabel = UILabel()
        titleLabel.text = "指定条件"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.sizeToFit()
        titleLabel.center = toolbar.center
        toolbar.addSubview(titleLabel)
        
        view.addSubview(toolbar)
    }
    
    private func setTableView() {
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: toolbar.frame.maxY,
            width: view.frame.width,
            height: view.frame.height - toolbar.frame.height
        ))
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Button Action
    
    @objc private func doneAction() {
        sendData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Action
    
    private func sendData() {
        if let tabBarController = self.presentingViewController as? MainTabBarController,
            let navigationController = tabBarController.selectedViewController as? UINavigationController,
            let presentingViewController = navigationController.topViewController as? ShelterTableViewController {
            presentingViewController.sortConditions = self.sortConditions
            presentingViewController.loadList()
        }
    }
}

extension SelectConditionTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let choicedType = choiceseList[indexPath.row][1] as? ConditionType else {
            return
        }
        if !sortConditions.contains(choicedType) {
            sortConditions.append(choiceseList[indexPath.row][1] as! ConditionType)
            cell?.accessoryType = .checkmark
        } else {
            let index = sortConditions.firstIndex(of: choicedType)!
            sortConditions.remove(at: index)
            cell?.accessoryType = .none
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        choiceseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = (choiceseList[indexPath.row].first as! String)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        guard let cellCondition = choiceseList[indexPath.row][1] as? ConditionType else {
            fatalError()
        }
        
        if sortConditions.contains(cellCondition) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}
