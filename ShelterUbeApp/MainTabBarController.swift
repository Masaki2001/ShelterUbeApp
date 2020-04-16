
import UIKit
import IoniconsSwift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: [UIViewController] = []
        
        let mapViewController = MapViewController()
        let mapVCImage = Ionicons.map.image(30)
        mapViewController.tabBarItem = UITabBarItem(title: "地図表示", image: mapVCImage, tag: 1)
        viewControllers.append(mapViewController)
        
        let shelterTableViewController = ShelterTableViewController()
        let shelterTableVCImage = Ionicons.iosList.image(30)
        shelterTableViewController.tabBarItem = UITabBarItem(title: "一覧", image: shelterTableVCImage, tag: 2)
        viewControllers.append(UINavigationController(rootViewController: shelterTableViewController))
        
        self.setViewControllers(viewControllers, animated: false)
        
        self.selectedIndex = 0
        
    }

}
