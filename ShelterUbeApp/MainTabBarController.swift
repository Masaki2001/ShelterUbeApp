
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: [UIViewController] = []
        
        let mapViewController = MapViewController()
        let mapVCImage = UIImage(systemName: "mappin.and.ellipse")
        mapViewController.tabBarItem = UITabBarItem(title: "地図表示", image: mapVCImage, tag: 1)
        viewControllers.append(mapViewController)
        
        let shelterTableViewController = ShelterTableViewController()
        let shelterTableVCImage = UIImage(systemName: "list.dash")
        shelterTableViewController.tabBarItem = UITabBarItem(title: "一覧", image: shelterTableVCImage, tag: 2)
        viewControllers.append(UINavigationController(rootViewController: shelterTableViewController))
        
        self.setViewControllers(viewControllers, animated: false)
        
        self.selectedIndex = 0
        
    }

}
