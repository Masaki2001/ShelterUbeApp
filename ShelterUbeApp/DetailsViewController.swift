
import UIKit

class DetailsViewController: UIViewController {
    
    // MAKR: Initaliazation
    init(shelter: Shelter) {
        self.shelter = shelter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    let nameLabel: UILabel = UILabel()
    let distanceLabel: UILabel = UILabel()
    let addressNameLabel: UILabel = UILabel()
    let potalCodeLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    let phoneNumberLabel: UILabel = UILabel()
    let emergencyEvacuationSiteLabel: UILabel = UILabel()
    let evacuationSiteLabel: UILabel = UILabel()
    let caseOfEarthquakeLabel: UILabel = UILabel()
    let caseOfTsunamiLabel: UILabel = UILabel()
    let caseOfSedimentDisasterLabel: UILabel = UILabel()
    let caseOfHighWavesIn100Label: UILabel = UILabel()
    let caseOfHighWavesIn500Label: UILabel = UILabel()
    let caseOfFloodLabel: UILabel = UILabel()
    let goRoute: UIButton = UIButton()
    
    let shelter: Shelter
    let scrollView = UIScrollView()
    
    let margin = (x: CGFloat(30), y: CGFloat(220.0))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        initSubView()
    }
    
    // MARK: Private Action
    
    func initSubView() {
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width - margin.x,
            height: view.frame.height - margin.y
        )
        nameLabel.frame = CGRect(x: 20, y: 40, width: 300, height: 20)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.text = shelter.name
        scrollView.addSubview(nameLabel)
        
        distanceLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY + 35, width: 300, height: 20)
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        distanceLabel.text = shelter.showDistance()
        scrollView.addSubview(distanceLabel)
        
        goRoute.frame = CGRect(x: 20, y: distanceLabel.frame.maxY + 7, width: 300, height: 20)
        goRoute.setTitle("ナビゲーションを開始する。", for: .normal)
        goRoute.contentHorizontalAlignment = .left
        goRoute.titleLabel?.adjustsFontSizeToFitWidth = true
        goRoute.setTitleColor(.systemBlue, for: .normal)
        goRoute.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        goRoute.addTarget(self, action: #selector(moveRouteAlert), for: .touchUpInside)
        scrollView.addSubview(goRoute)
        
        addressNameLabel.text = "住所"
        addressNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        addressNameLabel.frame = CGRect(x: 20, y: goRoute.frame.maxY + 25, width: 300, height: 20)
        scrollView.addSubview(addressNameLabel)
        
        potalCodeLabel.frame = CGRect(x: 20, y: addressNameLabel.frame.maxY + 7, width: 300, height: 20)
        potalCodeLabel.text = shelter.potalCode
        scrollView.addSubview(potalCodeLabel)
        
        addressLabel.frame = CGRect(x: 20, y: potalCodeLabel.frame.maxY + 7, width: 300, height: 20)
        addressLabel.text = shelter.address
        scrollView.addSubview(addressLabel)
        
        phoneNumberLabel.frame = CGRect(x: 20, y: addressLabel.frame.maxY + 7, width: 300, height: 20)
        phoneNumberLabel.text = shelter.phoneNumber
        scrollView.addSubview(phoneNumberLabel)
        
        emergencyEvacuationSiteLabel.frame = CGRect(x: 20, y: phoneNumberLabel.frame.maxY + 35, width: 300, height: 20)
        emergencyEvacuationSiteLabel.text = "緊急避難場所：" + changeString(bool: shelter.emergencyEvacuationSite)
        scrollView.addSubview(emergencyEvacuationSiteLabel)
        
        evacuationSiteLabel.frame = CGRect(x: 20, y: emergencyEvacuationSiteLabel.frame.maxY + 7, width: 300, height: 20)
        evacuationSiteLabel.text = "避難所：" + changeString(bool: shelter.evacuationSite)
        scrollView.addSubview(evacuationSiteLabel)
        
        caseOfEarthquakeLabel.frame = CGRect(x: 20, y: evacuationSiteLabel.frame.maxY + 7, width: 300, height: 20)
        caseOfEarthquakeLabel.text = "地震対応：" + changeString(bool: shelter.caseOfEarthquake)
        scrollView.addSubview(caseOfEarthquakeLabel)
        
        caseOfTsunamiLabel.frame = CGRect(x: 20, y: caseOfEarthquakeLabel.frame.maxY + 7, width: 300, height: 20)
        caseOfTsunamiLabel.text = "津波対応：" + changeString(bool: shelter.caseOfTsunami)
        scrollView.addSubview(caseOfTsunamiLabel)
        
        caseOfSedimentDisasterLabel.frame = CGRect(x: 20, y: caseOfTsunamiLabel.frame.maxY + 7, width: 300, height: 20)
        caseOfSedimentDisasterLabel.text = "土砂災害対応：" + changeString(bool: shelter.caseOfSedimentDisaster)
        scrollView.addSubview(caseOfSedimentDisasterLabel)
        
        caseOfHighWavesIn100Label.frame = CGRect(x: 20, y: caseOfSedimentDisasterLabel.frame.maxY + 7, width: 300, height: 20)
        caseOfHighWavesIn100Label.text = "高潮対応 100年に1度：" + changeString(bool: shelter.caseOfHighWavesIn100)
        scrollView.addSubview(caseOfHighWavesIn100Label)
        
        caseOfHighWavesIn500Label.frame = CGRect(x: 20, y: caseOfHighWavesIn100Label.frame.maxY + 7, width: 300, height: 20)
        caseOfHighWavesIn500Label.text = "高潮対応 500年に1度：" + changeString(bool: shelter.caseOfHighWavesIn500)
        scrollView.addSubview(caseOfHighWavesIn500Label)
        
        caseOfFloodLabel.frame = CGRect(x: 20, y: caseOfHighWavesIn500Label.frame.maxY + 7, width: 300, height: 20)
        caseOfFloodLabel.text = "洪水対応：" + changeString(bool: shelter.caseOfFlood)
        scrollView.addSubview(caseOfFloodLabel)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 100)
        view.addSubview(scrollView)
    }
    
    // MARK: Private Action
    
    @objc private func moveRouteAlert() {
        guard let presentingView = self.presentingViewController as? MainTabBarController,
            let mapViewController = presentingView.selectedViewController as? MapViewController else {
            return
        }
        
        let alert: UIAlertController = UIAlertController(
            title: "アプリを選択してください",
            message: "ルート案内を外部アプリで行います。",
            preferredStyle: .actionSheet
        )
        let actionAppleMap: UIAlertAction = UIAlertAction(
            title: "Apple Maps",
            style: .default,
            handler: { Void in
                mapViewController.routeInAppleMapApp(
                    targetName: self.shelter.name,
                    targetLat: self.shelter.location.coordinate.latitude,
                    targetLon: self.shelter.location.coordinate.longitude
                )
        })
        let actionGoogleMap: UIAlertAction = UIAlertAction(
            title: "Google Maps",
            style: .default,
            handler: { Void in
                mapViewController.routeInGoogleMap(
                    targetLat: self.shelter.location.coordinate.latitude,
                    targetLon: self.shelter.location.coordinate.longitude
                )
        })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(actionAppleMap)
        alert.addAction(actionGoogleMap)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeString(bool: Bool) -> String {
        return bool ? "○" : "×"
    }

}
