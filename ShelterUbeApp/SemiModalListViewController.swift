
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setLabel()
        fetchShelterAndSetMainView()
    }
    
    // MARK: SetUp
    private func setLabel() {
        titleLabel = UILabel(frame: CGRect(
            x: 20,
            y: 20,
            width: 300,
            height: 40
        ))
        titleLabel.text = "近くの避難所"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(titleLabel)
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
            y: titleLabel.frame.maxY + 20,
            width: view.frame.width,
            height: 350 - tabBarHeight
        ))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
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
