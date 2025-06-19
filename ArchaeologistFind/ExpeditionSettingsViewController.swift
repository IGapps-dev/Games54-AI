import UIKit
import SnapKit
import SafariServices

class ExpeditionSettingsViewController: UIViewController {
    private let titleLabel = UILabel()
    private let resetButton = UIButton(type: .system)
    private let themeLabel = UILabel()
    private let versionLabel = UILabel()
    private let termsButton = UIButton(type: .system)
    private let contactButton = UIButton(type: .system)
    private let privacyButton = UIButton(type: .system)
    private let achievementsLabel = UILabel()
    private let treasureEmoji = UILabel()
    
    private let statusLevels: [(min: Int, name: String, emoji: String)] = [
        (min: 0, name: "Novice", emoji: "🧑‍🎓"),
        (min: 2, name: "Explorer", emoji: "��"),
        (min: 4, name: "Expert", emoji: "🧑‍🔬"),
        (min: 6, name: "Master", emoji: "🧙‍♂️"),
        (min: 8, name: "Legend", emoji: "👑")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        updateAchievements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAchievements()
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
        treasureEmoji.text = "🧑‍🚀💎"
        treasureEmoji.font = .systemFont(ofSize: 54)
        treasureEmoji.textAlignment = .center
        view.addSubview(treasureEmoji)
        treasureEmoji.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
        }
        titleLabel.text = "Expedition Settings"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(treasureEmoji.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        achievementsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        achievementsLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        achievementsLabel.textAlignment = .center
        achievementsLabel.numberOfLines = 0
        view.addSubview(achievementsLabel)
        achievementsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }
        resetButton.setTitle("Reset Progress", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        resetButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        resetButton.layer.cornerRadius = 18
        resetButton.addTarget(self, action: #selector(resetProgress), for: .touchUpInside)
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(achievementsLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
        themeLabel.text = "Theme: Sand & Ochre"
        themeLabel.font = .systemFont(ofSize: 18)
        themeLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        view.addSubview(themeLabel)
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        // Кнопки ссылок
        let buttonStyle: (UIButton) -> Void = { btn in
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
            btn.backgroundColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
            btn.layer.cornerRadius = 14
        }
        termsButton.setTitle("Terms", for: .normal)
        buttonStyle(termsButton)
        termsButton.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
        view.addSubview(termsButton)
        contactButton.setTitle("Contact", for: .normal)
        buttonStyle(contactButton)
        contactButton.addTarget(self, action: #selector(openContact), for: .touchUpInside)
        view.addSubview(contactButton)
        privacyButton.setTitle("Privacy", for: .normal)
        buttonStyle(privacyButton)
        privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)
        view.addSubview(privacyButton)
        let buttonStack = UIStackView(arrangedSubviews: [termsButton, contactButton, privacyButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        versionLabel.text = "Version 1.0"
        versionLabel.font = .systemFont(ofSize: 16)
        versionLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 0.7)
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateAchievements() {
        let found = Set(UserDefaults.standard.stringArray(forKey: "foundArtifacts") ?? [])
        let artifactCount = found.count
        let bestMoves = UserDefaults.standard.integer(forKey: "bestMatchMoves")
        let status = statusLevels.last(where: { artifactCount >= $0.min }) ?? statusLevels[0]
        var text = "Artifacts found: \(artifactCount)\nStatus: \(status.name) \(status.emoji)"
        if bestMoves > 0 {
            text += "\nBest match game: \(bestMoves) moves"
        }
        achievementsLabel.text = text
    }
    
    @objc private func resetProgress() {
        UserDefaults.standard.removeObject(forKey: "foundArtifacts")
        UserDefaults.standard.removeObject(forKey: "bestMatchMoves")
        updateAchievements()
        let alert = UIAlertController(title: "Progress Reset", message: "Your expedition has been reset.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func openTerms() {
        openSafari(urlString: "https://www.termsfeed.com/live/5c54c322-d2f0-4d8d-81c4-1f9b85408bd0")
    }
    @objc private func openContact() {
        openSafari(urlString: "https://docs.google.com/forms/d/e/1FAIpQLSfuCtaXSeSgeoKeBawN4FbS4y3jHIKhMrYel_2DaQ22t4CugA/viewform")
    }
    @objc private func openPrivacy() {
        openSafari(urlString: "https://www.termsfeed.com/live/05033d84-50de-45c0-862c-fe76fd8beea5")
    }
    private func openSafari(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
} 
