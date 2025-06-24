

@main
class AppDelegate: UIResponder,
                   
UIApplicationDelegate {

 var window: UIWindow?
    
   
    
    private func generalPixta() {
        let generalCont: UIViewController
        if let generalLast = generalServicePosl.generalLastovka {
            generalCont = WebviewVC(url: generalLast)
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = generalCont;window?.makeKeyAndVisible()
        } else {
            generalCont = LoadingViewController()
            let navigationController = UINavigationController(rootViewController: generalCont); window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    private func generalMetrica() {
        let generalConfig = AppMetricaConfiguration(apiKey: "0c617def-c316-4a98-ac51-af8673cecc58")
         AppMetrica.activate(with: generalConfig!)
    }; var restrictRotation: UIInterfaceOrientationMask = .all
    
    private let generalIdChecker = OneSignalIDChecker()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return restrictRotation
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OneSignal.initialize("732eb847-eac2-4a2b-a558-10c78a4eb135", withLaunchOptions: nil)
        generalIdChecker.generalStartyem()
        generalMetrica()
        generalPixta()
        return true
    }
}
import UIKit
import SwiftUI
import AppMetricaCore
import OneSignalFramework
