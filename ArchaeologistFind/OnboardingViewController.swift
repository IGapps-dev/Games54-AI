import UIKit
import SnapKit

struct OnboardingPageContent {
    let title: String
    let subtitle: String
    let image: String
}

class OnboardingViewController: UIViewController {
    private let pages: [OnboardingPageContent] = [
        .init(title: "Welcome, Archaeologist!", subtitle: "Your adventure begins now.", image: "🧭"),
        .init(title: "Excavate Artifacts", subtitle: "Dig up relics from ancient civilizations.", image: "⛏️"),
        .init(title: "Match & Collect", subtitle: "Pair artifacts and complete your collection!", image: "🏺"),
        .init(title: "Ready to Explore?", subtitle: "Let the expedition begin!", image: "📜")
    ]
    private var currentPage = 0 {
        didSet { updateContent(animated: true) }
    }
    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let imageLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        updateContent(animated: false)
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
        imageLabel.font = .systemFont(ofSize: 70)
        imageLabel.textAlignment = .center
        view.addSubview(imageLabel)
        imageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
        }
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(32)
        }
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 0.5)
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
        }
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        skipButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        skipButton.layer.cornerRadius = 18
        skipButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        nextButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        nextButton.layer.cornerRadius = 18
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    private func updateContent(animated: Bool) {
        let page = pages[currentPage]
        let update = {
            self.imageLabel.text = page.image
            self.titleLabel.text = page.title
            self.subtitleLabel.text = page.subtitle
            self.pageControl.currentPage = self.currentPage
            if self.currentPage == self.pages.count - 1 {
                self.skipButton.setTitle("Start!", for: .normal)
                self.nextButton.isHidden = true
            } else {
                self.skipButton.setTitle("Skip", for: .normal)
                self.nextButton.isHidden = false
            }
        }
        if animated {
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: update)
        } else {
            update()
        }
    }
    
    @objc private func nextPage() {
        guard currentPage < pages.count - 1 else { return }
        currentPage += 1
    }
    
    @objc private func pageControlChanged() {
        currentPage = pageControl.currentPage
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left, currentPage < pages.count - 1 {
            currentPage += 1
        } else if gesture.direction == .right, currentPage > 0 {
            currentPage -= 1
        }
    }
    
    @objc private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingPassed")
        let mainTabBar = MainTabBarController()
        mainTabBar.modalTransitionStyle = .crossDissolve
        mainTabBar.modalPresentationStyle = .fullScreen
        present(mainTabBar, animated: true)
    }
} 