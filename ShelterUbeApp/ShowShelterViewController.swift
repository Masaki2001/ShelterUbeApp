
import UIKit
import MapKit

class ShowShelterViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    // MARK: Initialization
    
    init(shelter: Shelter) {
        self.shelter = shelter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    var shelter: Shelter
    let distanceLabel: UILabel = UILabel()
    let addressNameLabel: UILabel = UILabel()
    let potalCodeLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    let emergencyEvacuationSiteLabel: UILabel = UILabel()
    let evacuationSiteLabel: UILabel = UILabel()
    let caseOfEarthquakeLabel: UILabel = UILabel()
    let caseOfTsunamiLabel: UILabel = UILabel()
    let caseOfSedimentDisasterLabel: UILabel = UILabel()
    let caseOfHighWavesIn100Label: UILabel = UILabel()
    let caseOfHighWavesIn500Label: UILabel = UILabel()
    let caseOfFloodLabel: UILabel = UILabel()
    let scrollView = UIScrollView()
    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = shelter.name
        addGesture()
        setLayout()
    }
    
    // MARK: Private Action
    
    private func setLayout() {
        self.view.backgroundColor = .systemBackground
        
        scrollView.frame = CGRect(
            x: 0,
            y: self.navigationController?.navigationBar.frame.maxY ?? 0,
            width: view.frame.width,
            height: view.frame.height
        )
        
        addressNameLabel.text = "住所"
        addressNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        addressNameLabel.frame = CGRect(x: 20, y: 40, width: 300, height: 20)
        scrollView.addSubview(addressNameLabel)
        
        potalCodeLabel.frame = CGRect(x: 20, y: addressNameLabel.frame.maxY + 7, width: 300, height: 20)
        potalCodeLabel.text = shelter.potalCode
        scrollView.addSubview(potalCodeLabel)
        
        addressLabel.frame = CGRect(x: 20, y: potalCodeLabel.frame.maxY + 7, width: 300, height: 20)
        addressLabel.text = shelter.address
        scrollView.addSubview(addressLabel)
        
        setMapView()
        
        emergencyEvacuationSiteLabel.frame = CGRect(x: 20, y: mapView.frame.maxY + 35, width: 300, height: 20)
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
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: caseOfFloodLabel.frame.maxY + 100)
        view.addSubview(scrollView)
    }
    
    private func setMapView() {
        mapView = MKMapView()
        mapView.frame = CGRect(
            x: 20,
            y: addressLabel.frame.maxY + 40,
            width: scrollView.frame.width - 40,
            height: scrollView.frame.width - 40
        )
        mapView.layer.cornerRadius = 10
        
        mapView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(showAnotherApp))]
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = shelter.location.coordinate
        annotation.title = shelter.name
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005
        )
        let region = MKCoordinateRegion(
            center: shelter.location.coordinate,
            span: span
        )
        mapView.setRegion(region, animated: true)
        
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        
        scrollView.addSubview(mapView)
    }
    
    private func addGesture() {
        if let popGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            popGestureRecognizer.delegate = self
        }
    }
    
    private func changeString(bool: Bool) -> String {
        return bool ? "○" : "×"
    }
    
    @objc func showAnotherApp() {
        let alert: UIAlertController = UIAlertController(
            title: "他のアプリで開く",
            message: "アプリを選択",
            preferredStyle: .actionSheet
        )
        let actionAppleMap: UIAlertAction = UIAlertAction(
            title: "Apple Maps",
            style: .default,
            handler: { Void in
                self.showInAppleMapApp()
        })
        let actionGoogleMap: UIAlertAction = UIAlertAction(
            title: "Google Maps",
            style: .default,
            handler: { Void in
                self.showInGoogleMap()
        })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル", style: .cancel, handler: nil)
        
        alert.addAction(actionAppleMap)
        alert.addAction(actionGoogleMap)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showInAppleMapApp() {
        let coordinates = shelter.location.coordinate
        let regionDistance = 0.04
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
          MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
          MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shelter.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func showInGoogleMap() {
        let zoom = 15
        let encoded = shelter.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "comgooglemaps://?q=\(encoded)?center=\(shelter.location.coordinate.latitude),\(shelter.location.coordinate.longitude)&zoom=\(zoom)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
