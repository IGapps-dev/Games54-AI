import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        view.backgroundColor = .white
    }
    
    private func setupTabBar() {
        let excavationVC = UINavigationController(rootViewController: ExcavationViewController())
        excavationVC.tabBarItem = UITabBarItem(title: "Dig", image: UIImage(systemName: "hammer"), selectedImage: nil)
        
        let catalogVC = UINavigationController(rootViewController: CatalogViewController())
        catalogVC.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "books.vertical"), selectedImage: nil)
        
        let matchGameVC = UINavigationController(rootViewController: MatchGameViewController())
        matchGameVC.tabBarItem = UITabBarItem(title: "Match", image: UIImage(systemName: "puzzlepiece"), selectedImage: nil)
        
        let journalVC = UINavigationController(rootViewController: JournalViewController())
        journalVC.tabBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: "scroll"), selectedImage: nil)
        
        let settingsVC = UINavigationController(rootViewController: ExpeditionSettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: nil)
        
        viewControllers = [excavationVC, catalogVC, matchGameVC, journalVC, settingsVC]
        // Яркий светлый фон
        let brightGradient = CAGradientLayer()
        brightGradient.colors = [
            UIColor(red: 1.0, green: 0.98, blue: 0.92, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.90, blue: 0.70, alpha: 1).cgColor
        ]
        brightGradient.frame = tabBar.bounds
        if let image = getImageFrom(gradientLayer: brightGradient) {
            tabBar.backgroundImage = image
        }
        tabBar.tintColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1) // насыщенный тёмно-коричневый
        tabBar.unselectedItemTintColor = UIColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1)
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
        // Настройка appearance для жирного шрифта и увеличенного размера
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1),
            .font: UIFont.boldSystemFont(ofSize: 14),
            .shadow: NSShadow().apply {
                $0.shadowColor = UIColor.white
                $0.shadowBlurRadius = 2
            }
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1),
            .font: UIFont.boldSystemFont(ofSize: 13)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.65, green: 0.55, blue: 0.35, alpha: 1)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

private extension NSShadow {
    func apply(_ block: (NSShadow) -> Void) -> NSShadow {
        block(self)
        return self
    }
} 