import UIKit
import SnapKit


class ExcavationViewController: UIViewController {
    private let titleLabel = UILabel()
    private let sandView = UIView()
    private let digButton = UIButton(type: .system)
    private let artifactLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .bar)
    private let statusLabel = UILabel()
    private let quizContainer = UIView()
    private let quizQuestionLabel = UILabel()
    private var quizButtons: [UIButton] = []
    private let allArtifacts: [Artifact] = [
        Artifact(emoji: "🏺", name: "Vase", description: "Ancient vases were used to store food, water, and precious items."),
        Artifact(emoji: "🗿", name: "Statue", description: "Mysterious statues from ancient civilizations, often used for rituals."),
        Artifact(emoji: "⚱️", name: "Urn", description: "Urns were typically used to hold ashes or sacred offerings."),
        Artifact(emoji: "🪙", name: "Coin", description: "Old coins made of gold or silver, used for trade and commerce."),
        Artifact(emoji: "📦", name: "Crate", description: "Wooden crates were used to transport goods across lands."),
        Artifact(emoji: "🧭", name: "Compass", description: "Compasses guided explorers through unknown territories."),
        Artifact(emoji: "🧩", name: "Puzzle Piece", description: "Puzzle pieces from ancient games and riddles."),
        Artifact(emoji: "🪔", name: "Oil Lamp", description: "Oil lamps lit up the dark nights of ancient cities."),
        Artifact(emoji: "🪓", name: "Axe", description: "Axes were essential tools for both work and battle."),
        Artifact(emoji: "🪶", name: "Feather", description: "Feathers were used for writing and decoration."),
        Artifact(emoji: "📜", name: "Scroll", description: "Scrolls contained valuable knowledge and stories."),
        Artifact(emoji: "🧱", name: "Brick", description: "Bricks built the foundations of ancient architecture."),
        Artifact(emoji: "🗝️", name: "Key", description: "Keys unlocked the secrets of the past."),
        Artifact(emoji: "🪙", name: "Medal", description: "Medals were awarded to heroes and champions."),
        Artifact(emoji: "🦴", name: "Bone", description: "Bones tell the story of ancient creatures and people."),
        Artifact(emoji: "🧪", name: "Vial", description: "Vials held potions and mysterious substances."),
        Artifact(emoji: "🧤", name: "Glove", description: "Gloves protected hands during excavations."),
        Artifact(emoji: "🧲", name: "Magnet", description: "Magnets fascinated ancient scientists."),
        Artifact(emoji: "🧹", name: "Broom", description: "Brooms swept away the sands of time."),
        Artifact(emoji: "🪄", name: "Wand", description: "Wands were believed to hold magical powers.")
    ]
    private var foundArtifacts: [String] = []
    private var currentArtifactIndex: Int?
    private let statusLevels = [
        (min: 0, name: "Novice", emoji: "🧑‍🎓"),
        (min: 2, name: "Explorer", emoji: "🧭"),
        (min: 4, name: "Explorer", emoji: "🧑‍🔬"),
        (min: 6, name: "Master", emoji: "🧙‍♂️"),
        (min: 8, name: "Legend", emoji: "👑")
    ]
    
    private struct Quiz {
        let question: String
        let options: [String]
        let correct: Int
    }

    private let quizPool: [Quiz] = [
        Quiz(question: "What was this artifact used for?", options: ["Storing food", "Writing", "Weapon"], correct: 0),
        Quiz(question: "Which civilization is famous for these statues?", options: ["Egyptians", "Easter Island", "Romans"], correct: 1),
        Quiz(question: "What did urns usually contain?", options: ["Water", "Ashes", "Jewelry"], correct: 1),
        Quiz(question: "What metal were ancient coins often made of?", options: ["Gold", "Plastic", "Glass"], correct: 0),
        Quiz(question: "What was the main use of crates?", options: ["Transporting goods", "Cooking", "Decoration"], correct: 0),
        Quiz(question: "What is the main purpose of a compass?", options: ["Navigation", "Decoration", "Cooking"], correct: 0),
        Quiz(question: "What is a scroll usually made of?", options: ["Papyrus", "Plastic", "Stone"], correct: 0),
        Quiz(question: "What is a puzzle piece part of?", options: ["A game", "A tool", "A weapon"], correct: 0),
        Quiz(question: "What did oil lamps use as fuel?", options: ["Oil", "Water", "Sand"], correct: 0),
        Quiz(question: "What is an axe mainly used for?", options: ["Cutting", "Writing", "Measuring"], correct: 0),
        Quiz(question: "What is a feather used for in ancient times?", options: ["Writing", "Cooking", "Building"], correct: 0),
        Quiz(question: "What is a brick used for?", options: ["Building", "Eating", "Sewing"], correct: 0),
        Quiz(question: "What does a key unlock?", options: ["A lock", "A book", "A lamp"], correct: 0),
        Quiz(question: "What is a medal awarded for?", options: ["Achievement", "Punishment", "Cooking"], correct: 0),
        Quiz(question: "What are bones evidence of?", options: ["Life", "Weather", "Jewelry"], correct: 0),
        Quiz(question: "What is a vial used for?", options: ["Holding liquids", "Writing", "Cutting"], correct: 0),
        Quiz(question: "What do gloves protect?", options: ["Hands", "Feet", "Head"], correct: 0),
        Quiz(question: "What does a magnet attract?", options: ["Metal", "Wood", "Water"], correct: 0),
        Quiz(question: "What is a broom used for?", options: ["Sweeping", "Cooking", "Writing"], correct: 0),
        Quiz(question: "What is a wand associated with?", options: ["Magic", "Cooking", "Building"], correct: 0),
        Quiz(question: "What is the main use of a coin?", options: ["Trade", "Decoration", "Weapon"], correct: 0),
        Quiz(question: "What is a crate made of?", options: ["Wood", "Glass", "Paper"], correct: 0),
        Quiz(question: "What is a compass needle made of?", options: ["Metal", "Plastic", "Stone"], correct: 0),
        Quiz(question: "What is a scroll used for?", options: ["Writing", "Cooking", "Building"], correct: 0),
        Quiz(question: "What is a puzzle piece made of?", options: ["Wood", "Metal", "Glass"], correct: 0),
        Quiz(question: "What is an oil lamp used for?", options: ["Lighting", "Cooking", "Measuring"], correct: 0),
        Quiz(question: "What is an axe made of?", options: ["Metal & Wood", "Plastic", "Stone only"], correct: 0),
        Quiz(question: "What is a feather a symbol of?", options: ["Writing", "Strength", "Wealth"], correct: 0),
        Quiz(question: "What is a brick's main property?", options: ["Strength", "Flexibility", "Transparency"], correct: 0),
        Quiz(question: "What is a key made for?", options: ["Unlocking", "Cooking", "Writing"], correct: 0)
    ]

    private var currentQuiz: Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        loadArtifacts()
        updateProgressAndStatus()
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
        titleLabel.text = "Excavation Site"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        statusLabel.font = .boldSystemFont(ofSize: 18)
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        progressBar.progressTintColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        progressBar.trackTintColor = UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 0.5)
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(8)
        }
        sandView.backgroundColor = UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 0.7)
        sandView.layer.cornerRadius = 50
        view.addSubview(sandView)
        sandView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        artifactLabel.font = .systemFont(ofSize: 48)
        artifactLabel.textAlignment = .center
        artifactLabel.alpha = 0
        sandView.addSubview(artifactLabel)
        artifactLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        digButton.setTitle("Dig ⛏️", for: .normal)
        digButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        digButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        digButton.setTitleColor(.white, for: .normal)
        digButton.layer.cornerRadius = 20
        digButton.addTarget(self, action: #selector(digAction), for: .touchUpInside)
        view.addSubview(digButton)
        digButton.snp.makeConstraints { make in
            make.top.equalTo(sandView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        quizContainer.alpha = 0
        quizContainer.layer.cornerRadius = 18
        quizContainer.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.80, alpha: 0.97)
        view.addSubview(quizContainer)
        quizContainer.snp.makeConstraints { make in
            make.top.equalTo(digButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-12)
        }
        quizQuestionLabel.font = .boldSystemFont(ofSize: 16)
        quizQuestionLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        quizQuestionLabel.textAlignment = .center
        quizQuestionLabel.numberOfLines = 0
        quizContainer.addSubview(quizQuestionLabel)
        quizQuestionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(8)
        }
        for i in 0..<3 {
            let btn = UIButton(type: .system)
            btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
            btn.layer.cornerRadius = 12
            btn.tag = i
            btn.addTarget(self, action: #selector(quizAnswerTapped(_:)), for: .touchUpInside)
            quizContainer.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.top.equalTo(quizQuestionLabel.snp.bottom).offset(12 + i*44)
                make.left.right.equalToSuperview().inset(10)
                make.height.equalTo(36)
            }
            quizButtons.append(btn)
        }
        quizContainer.snp.makeConstraints { make in
            make.bottom.equalTo(quizButtons.last!.snp.bottom).offset(12)
        }
    }
    
    @objc private func digAction() {
        let idx = Int.random(in: 0..<allArtifacts.count)
        let artifact = allArtifacts[idx]
        currentArtifactIndex = idx
        artifactLabel.text = artifact.emoji
        artifactLabel.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.artifactLabel.alpha = 1
            self.sandView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.sandView.transform = .identity
            })
            self.showQuiz(for: idx)
        }
        if !foundArtifacts.contains(artifact.emoji) {
            foundArtifacts.append(artifact.emoji)
            saveArtifacts()
            updateProgressAndStatus()
        }
    }
    
    private func showQuiz(for idx: Int) {
        let artifact = allArtifacts[idx]
        let quiz = quizPool.randomElement()!
        currentQuiz = quiz
        quizQuestionLabel.text = quiz.question
        for (i, btn) in quizButtons.enumerated() {
            btn.setTitle(quiz.options[i], for: .normal)
            btn.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
            btn.isEnabled = true
            btn.isHidden = false
        }
        if quizButtons.count > 3 {
            for i in 3..<quizButtons.count {
                quizButtons[i].isHidden = true
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.quizContainer.alpha = 1
        }
    }
    
    @objc private func quizAnswerTapped(_ sender: UIButton) {
        guard let quiz = currentQuiz else { hideQuiz(); return }
        let correct = quiz.correct
        for (i, btn) in quizButtons.enumerated() where i < 3 {
            btn.isEnabled = false
            if i == correct {
                btn.backgroundColor = UIColor(red: 0.45, green: 0.8, blue: 0.32, alpha: 1)
            } else if i == sender.tag {
                btn.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.hideQuiz()
        }
    }
    
    @objc private func hideQuiz() {
        UIView.animate(withDuration: 0.4) {
            self.quizContainer.alpha = 0
        }
    }
    
    private func updateProgressAndStatus() {
        let progress = allArtifacts.isEmpty ? 0 : Float(foundArtifacts.count) / Float(allArtifacts.count)
        progressBar.setProgress(progress, animated: true)
        let status = statusLevels.last(where: { foundArtifacts.count >= $0.min }) ?? statusLevels[0]
        statusLabel.text = "Status: \(status.name) \(status.emoji)"
    }
    
    private func saveArtifacts() {
        UserDefaults.standard.set(foundArtifacts, forKey: "foundArtifacts")
    }
    private func loadArtifacts() {
        foundArtifacts = UserDefaults.standard.stringArray(forKey: "foundArtifacts") ?? []
    }
} 
