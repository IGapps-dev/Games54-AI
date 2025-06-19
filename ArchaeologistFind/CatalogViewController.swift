import UIKit
import SnapKit

struct Artifact {
    let emoji: String
    let name: String
    let description: String
}

class CatalogViewController: UIViewController {
    private var allArtifacts: [Artifact] = [
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
    private var artifacts: [Artifact] = []
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    private let descriptionView = UIView()
    private let descriptionLabel = UILabel()
    private let nameLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 130)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        loadArtifacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        artifacts = allArtifacts
        collectionView.reloadData()
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
        titleLabel.text = "Artifact Catalog"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ArtifactCell.self, forCellWithReuseIdentifier: "ArtifactCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
        // Description popup
        descriptionView.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.80, alpha: 0.98)
        descriptionView.layer.cornerRadius = 24
        descriptionView.layer.borderWidth = 2
        descriptionView.layer.borderColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 0.5).cgColor
        descriptionView.alpha = 0
        view.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        nameLabel.textAlignment = .center
        descriptionView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        descriptionLabel.font = .systemFont(ofSize: 18)
        descriptionLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 0.9)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        closeButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        closeButton.layer.cornerRadius = 16
        closeButton.addTarget(self, action: #selector(hideDescription), for: .touchUpInside)
        descriptionView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func loadArtifacts() {
        let foundEmojis = Set(UserDefaults.standard.stringArray(forKey: "foundArtifacts") ?? [])
        artifacts = allArtifacts.filter { foundEmojis.contains($0.emoji) }
        collectionView.reloadData()
    }
    
    @objc private func hideDescription() {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.alpha = 0
        }
    }
    
    private func showDescription(for artifact: Artifact) {
        nameLabel.text = "\(artifact.emoji)  \(artifact.name)"
        descriptionLabel.text = artifact.description
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.alpha = 1
        }
    }
    
    private func deleteArtifact(at index: Int) {
        let emoji = artifacts[index].emoji
        var found = UserDefaults.standard.stringArray(forKey: "foundArtifacts") ?? []
        found.removeAll { $0 == emoji }
        UserDefaults.standard.set(found, forKey: "foundArtifacts")
        loadArtifacts()
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artifacts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtifactCell", for: indexPath) as! ArtifactCell
        cell.configure(with: artifacts[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDescription(for: artifacts[indexPath.item])
    }
    // Swipe to delete
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteArtifact(at: indexPath.item)
            completion(true)
        }
        delete.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

class ArtifactCell: UICollectionViewCell {
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.80, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 0.5).cgColor
        emojiLabel.font = .systemFont(ofSize: 44)
        emojiLabel.textAlignment = .center
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(4)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with artifact: Artifact) {
        emojiLabel.text = artifact.emoji
        nameLabel.text = artifact.name
    }
} 