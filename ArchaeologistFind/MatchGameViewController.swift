import UIKit
import SnapKit

class MatchGameViewController: UIViewController {
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    private var artifactPairs: [String] = []
    private var openedIndices: [IndexPath] = []
    private var matchedIndices: Set<IndexPath> = []
    private let allArtifacts = ["🏺", "🗿", "⚱️", "🪙", "📦", "🧭", "🧩", "🪔", "🪓", "🪶", "📜", "🧱", "🗝️", "🦴", "🧪", "🧤", "🧲", "🧹", "🪄"]
    private var moves = 0
    private let movesLabel = UILabel()
    private let scoreLabel = UILabel()
    private let streakLabel = UILabel()
    private let levelLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .bar)
    private var score = 0
    private var streak = 0
    private var level = 1
    private var pairsPerLevel: [Int] = [3, 4, 5, 6, 7, 8, 9]
    private var maxLevel: Int { pairsPerLevel.count }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 18
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        startNewGame()
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
        titleLabel.text = "Match the Artifacts!"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }
        levelLabel.font = .boldSystemFont(ofSize: 18)
        levelLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        levelLabel.textAlignment = .center
        view.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        progressBar.progressTintColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        progressBar.trackTintColor = UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 0.5)
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(8)
        }
        movesLabel.font = .systemFont(ofSize: 16)
        movesLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 0.8)
        movesLabel.textAlignment = .center
        view.addSubview(movesLabel)
        movesLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        scoreLabel.font = .boldSystemFont(ofSize: 18)
        scoreLabel.textColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        scoreLabel.textAlignment = .left
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalTo(movesLabel)
        }
        streakLabel.font = .boldSystemFont(ofSize: 18)
        streakLabel.textColor = UIColor(red: 0.45, green: 0.7, blue: 0.32, alpha: 1)
        streakLabel.textAlignment = .right
        view.addSubview(streakLabel)
        streakLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(movesLabel)
        }
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MatchCardCell.self, forCellWithReuseIdentifier: "MatchCardCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(movesLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func startNewGame() {
        let pairsCount = pairsPerLevel[min(level-1, pairsPerLevel.count-1)]
        let selected = allArtifacts.shuffled().prefix(pairsCount)
        artifactPairs = Array(selected + selected).shuffled()
        openedIndices = []
        matchedIndices = []
        moves = 0
        streak = 0
        updateLabels()
        collectionView.reloadData()
        updateProgressBar()
    }
    
    private func updateLabels() {
        movesLabel.text = "Moves: \(moves)"
        scoreLabel.text = "Score: \(score)"
        streakLabel.text = streak > 1 ? "🔥 Streak: \(streak)" : ""
        levelLabel.text = "Level: \(level) / \(maxLevel)"
    }
    
    private func updateProgressBar() {
        let total = pairsPerLevel[min(level-1, pairsPerLevel.count-1)] * 2
        let progress = total == 0 ? 0 : Float(matchedIndices.count) / Float(total)
        progressBar.setProgress(progress, animated: true)
    }
}

extension MatchGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artifactPairs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCardCell", for: indexPath) as! MatchCardCell
        let isOpened = openedIndices.contains(indexPath) || matchedIndices.contains(indexPath)
        cell.configure(isOpened: isOpened, emoji: isOpened ? artifactPairs[indexPath.item] : "🪨")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !openedIndices.contains(indexPath), !matchedIndices.contains(indexPath), openedIndices.count < 2 else { return }
        openedIndices.append(indexPath)
        collectionView.reloadItems(at: [indexPath])
        if openedIndices.count == 2 {
            moves += 1
            updateLabels()
            let first = openedIndices[0]
            let second = openedIndices[1]
            if artifactPairs[first.item] == artifactPairs[second.item] {
                matchedIndices.insert(first)
                matchedIndices.insert(second)
                streak += 1
                score += 10 * streak
                updateLabels()
                updateProgressBar()
                openedIndices = []
                if matchedIndices.count == artifactPairs.count {
                    if level < maxLevel {
                        level += 1
                        let alert = UIAlertController(title: "Level Up!", message: "Welcome to Level \(level)!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Next", style: .default) { _ in
                            self.startNewGame()
                        })
                        present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Victory!", message: "You completed all levels!\nTotal Score: \(score)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
                            self.level = 1
                            self.score = 0
                            self.startNewGame()
                        })
                        present(alert, animated: true)
                    }
                }
            } else {
                streak = 0
                updateLabels()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.openedIndices = []
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

class MatchCardCell: UICollectionViewCell {
    private let emojiLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.80, alpha: 1)
        contentView.layer.cornerRadius = 14
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 0.5).cgColor
        emojiLabel.font = .systemFont(ofSize: 38)
        emojiLabel.textAlignment = .center
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(isOpened: Bool, emoji: String) {
        emojiLabel.text = emoji
        emojiLabel.alpha = isOpened ? 1 : 0.5
    }
} 