import UIKit

@main
class AppDelegate: UIResponder,

UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let loadingVC = LoadingViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = loadingVC
        self.window?.makeKeyAndVisible()
        return true
    }
    
}
