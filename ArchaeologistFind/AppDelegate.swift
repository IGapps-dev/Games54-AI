

@main
class AppDelegate: UIResponder,
                   
UIApplicationDelegate {

 var window: UIWindow?
    
   
    
    private func ArchaeologistPixta() {
        let ArchaeologistCont: UIViewController
        if let ArchaeologistLast = ArchaeologistServicePosl.ArchaeologistLastovka {
            ArchaeologistCont = WebviewVC(url: ArchaeologistLast)
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = ArchaeologistCont;window?.makeKeyAndVisible()
        } else {
            ArchaeologistCont = LoadingViewController()
            let navigationController = UINavigationController(rootViewController: ArchaeologistCont); window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    private func ArchaeologistMetrica() {
        let ArchaeologistConfig = AppMetricaConfiguration(apiKey: "0c617def-c316-4a98-ac51-af8673cecc58")
         AppMetrica.activate(with: ArchaeologistConfig!)
    }; var restrictRotation: UIInterfaceOrientationMask = .all
    
    private let ArchaeologistIdChecker = OneSignalIDChecker()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return restrictRotation
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OneSignal.initialize("732eb847-eac2-4a2b-a558-10c78a4eb135", withLaunchOptions: nil)
        ArchaeologistIdChecker.ArchaeologistStartyem()
        ArchaeologistMetrica()
        ArchaeologistPixta()
        return true
    }
}
import UIKit
import SwiftUI
import AppMetricaCore
import OneSignalFramework
