
import UIKit
import MapKit
import CoreLocation
import AudioToolbox
import FloatingPanel

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    let mapView: MKMapView = MKMapView()
    var locationManager: CLLocationManager!
    var floatingPanelController: FloatingPanelController!
    var semiModalController: SemiModalListViewController!
    var list: [Shelter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchData = FetchShelter()
        fetchData.fetchData()
        setSemiModalListVC()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        setupLocationManagerIfNeeded()
        initMapView()
        addAnnotationToMapView()
        setFloatingPanel()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.updateLocationmanager), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: Action
    
    func addAnnotationToMapView() {
        for shelter in Shelter.list {
            addAnnotation(title: shelter.name, latitude: shelter.location.coordinate.latitude, longitude: shelter.location.coordinate.longitude)
        }
    }
    
    func moveSelectedCenter() {
        let center = CLLocationCoordinate2D(
            latitude: 35.658761,
            longitude: 139.701362
        )
        let origin = MKMapPoint(center)
        let size = MKMapSize(width: 0.2, height: 0.2)
        let rect = MKMapRect(origin: origin, size: size)
        mapView.setVisibleMapRect(rect, animated: true)
        print("Hit!")
    }
    
    func routeInAppleMapApp(targetName: String, targetLat: CLLocationDegrees, targetLon: CLLocationDegrees) {
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        let currentDistance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let targetDistance = CLLocation(latitude: targetLat, longitude: targetLon)
        let regionDistance = currentDistance.distance(from: targetDistance) + 20
        
        let startCoords = CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude)
        let regionSpan = MKCoordinateRegion(center: startCoords, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let targetCoords = CLLocationCoordinate2DMake(targetLat, targetLon)
        
        let startPlacemark = MKPlacemark(coordinate: startCoords, addressDictionary: nil)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        startMapItem.name = "現在地"
        
        let targetPlacemark = MKPlacemark(coordinate: targetCoords, addressDictionary: nil)
        let targetMapItem = MKMapItem(placemark: targetPlacemark)
        targetMapItem.name = targetName
        
        let options: [String : Any] = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        MKMapItem.openMaps(with: [startMapItem, targetMapItem], launchOptions: options)
    }
    
    func routeInGoogleMap(targetLat: CLLocationDegrees, targetLon: CLLocationDegrees) {
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }
        let startLat = userLocation.latitude
        let startLon = userLocation.longitude
        let zoom = 10
        let directionsMode = "walking"
        
        let url = URL(string: "comgooglemaps://?saddr=\(startLat),\(startLon)&daddr=\(targetLat),\(targetLon)&zoom=\(zoom)&directionsmode=\(directionsMode)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func alertRequestCLLocationManager() {
        let alert: UIAlertController = UIAlertController(
            title: "現在地取得に失敗しました。",
            message: "現在地取得を有効にしてください",
            preferredStyle: .alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK", style: .default, handler: {Void in
                let url = URL(string: "app-settings:root=General&path=com.masaki.ShelterUbeApp")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Private Action
    
    private func setupLocationManagerIfNeeded() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setSemiModalListVC() {
        semiModalController = SemiModalListViewController()
        semiModalController.tabBarHeight = self.tabBarController?.tabBar.frame.height
    }
    
    private func initMapView() {
        mapView.delegate = self
        mapView.frame = view.bounds
        mapView.showsUserLocation = true
        
        if let userLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: false)
        }
        let topView = UIVisualEffectView()
        topView.frame = CGRect(
            x: view.frame.minX,
            y: view.frame.minY,
            width: view.frame.width,
            height: 22
        )
        topView.isOpaque = false
        topView.backgroundColor = .clear
        topView.effect = UIBlurEffect(style: .light)
        topView.alpha = 0.2
        mapView.addSubview(topView)
        view.addSubview(mapView)
    }
    
    private func setFloatingPanel() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 10.0
        floatingPanelController.set(contentViewController: semiModalController)
        
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
    }
    
    private func addAnnotation(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    @objc private func updateLocationmanager() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            setupLocationManagerIfNeeded()
        } else {
            semiModalController.loseCurrentLocation()
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        AudioServicesPlaySystemSound( 1520 )
        guard let annotation = view.annotation, let title = annotation.title! else {
            return
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
        guard let userLocation = locationManager.location?.coordinate else {
            alertRequestCLLocationManager()
            return
        }
        let shelter = Shelter.find_by_name(string: title)!
        shelter.targetLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let modalViewController = DetailsViewController(shelter: shelter)
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        present(modalViewController, animated: true, completion: nil)
    }
    
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let destinationViewController = semiModalController else { return }
        guard let currentLocation = locations.first else { return }
        destinationViewController.loadShelters(currentLocation: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                guard let currentLocation = locationManager.location else { return }
                guard let destinationViewController = semiModalController else { return }
                destinationViewController.loadShelters(currentLocation: currentLocation)
            default:
                break
        }
    }
}

extension MapViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
}
