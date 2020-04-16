
import UIKit
import MapKit
import CoreLocation

class SemiModalListViewController: UIViewController {
    
    // MARK: Properties
    var userLocation: CLLocation?
    var shelters: [Shelter] = []
    var titleLabel: UILabel!
    var tableView: UITableView!
    var warningLabel: UILabel!
    var tabBarHeight: CGFloat!
    var segumentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setSegumentControl()
        setLabel()
        fetchShelterAndSetMainView()
    }
    
    // MARK: SetUp
    
    private func setSegumentControl() {
        let params = ["マップ", "交通機関", "航空写真"]
        segumentControl = UISegmentedControl(items: params)
        segumentControl.frame.size = CGSize(
            width: view.frame.width - 40,
            height: 30
        )
        segumentControl.center = CGPoint(
            x: view.center.x,
            y: 30 + segumentControl.frame.height / 2
        )
        segumentControl.selectedSegmentIndex = 0
        segumentControl.addTarget(self, action: #selector(changeMapType(segument:)), for: .valueChanged)
        view.addSubview(segumentControl)
    }
    
    private func setLabel() {
        titleLabel = UILabel(frame: CGRect(
            x: 20,
            y: segumentControl.frame.maxY + 20,
            width: view.frame.width - 40,
            height: 40
        ))
        titleLabel.text = "近くの避難所"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.systemGray
        view.addSubview(titleLabel)
    }
    
    private func setWarningLabel() {
        warningLabel = UILabel()
        warningLabel.text = "現在地を取得できていません。"
        warningLabel.sizeToFit()
        warningLabel.center = CGPoint(
            x: self.view.frame.width / 2,
            y: self.view.frame.width / 4 + titleLabel.frame.maxY
        )
        view.addSubview(warningLabel)
    }
    
    private func setTableView() {
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: titleLabel.frame.maxY + 10,
            width: view.frame.width,
            height: view.frame.height - tabBarHeight - titleLabel.frame.maxY - 10
        ))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    // MARK: Action
    
    func loadShelters(currentLocation: CLLocation) {
        self.userLocation = currentLocation
        if (tableView == nil) {
            warningLabel.removeFromSuperview()
            setTableView()
        } else if !view.isDescendant(of: tableView) {
            warningLabel.removeFromSuperview()
            view.addSubview(tableView)
        }
        shelters = Shelter.sortedList(nearFrom: currentLocation)
        tableView.reloadData()
    }
    
    func loseCurrentLocation() {
        self.userLocation = nil
        guard tableView != nil else { return }
        tableView.removeFromSuperview()
        setWarningLabel()
    }
    
    // MARK: Private Action
    
    private func fetchShelterAndSetMainView() {
        
        if let currentLocation = userLocation {
            shelters = Shelter.sortedList(nearFrom: currentLocation)
            setTableView()
        } else {
            setWarningLabel()
        }
    }
    
    @objc private func changeMapType(segument: UISegmentedControl) {
        switch segument.selectedSegmentIndex {
            case 0:
                NotificationCenter.default.post(
                    Notification(name: Notification.Name("SetMapType"), object: nil, userInfo: ["type": MKMapType.standard])
                )
            case 1:
                NotificationCenter.default.post(
                    Notification(name: Notification.Name("SetMapType"), object: nil, userInfo: ["type": MKMapType.mutedStandard])
                )
            case 2:
                NotificationCenter.default.post(
                    Notification(name: Notification.Name("SetMapType"), object: nil, userInfo: ["type": MKMapType.satellite])
                )
            default:
                fatalError()
        }
    }
}

extension SemiModalListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShelter = shelters[indexPath.row]
        NotificationCenter.default.post(
            Notification(name: Notification.Name("MoveSelectedCenter"), object: nil, userInfo: ["shelter": selectedShelter])
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shelters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shelter = shelters[indexPath.row]
        shelter.targetLocation = userLocation
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = shelter.name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.detailTextLabel?.text = (shelter.distance != nil) ? shelter.showDistance() : "データの取得に失敗"
        return cell
    }
}
