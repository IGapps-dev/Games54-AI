import UIKit
import SnapKit

class JournalViewController: UIViewController {
    private let titleLabel = UILabel()
    private let filterSegment = UISegmentedControl(items: ["All", "Artifacts", "Records", "Quotes"])
    private let tableView = UITableView()
    private let exportButton = UIButton(type: .system)
    private let quoteLabel = UILabel()
    private var events: [JournalEvent] = []
    private var filteredEvents: [JournalEvent] = []
    private let quotes = [
        "Archaeology is the peep-hole into the past. 🏺",
        "Every artifact has a story to tell. 🗿",
        "The greatest treasure is the journey itself. 🧭",
        "Digging up the past, we discover ourselves. 🧑‍🎓",
        "History is written in the sands. ⏳"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupViews()
        loadJournal()
        showRandomQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadJournal()
    }
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.98, green: 0.93, blue: 0.80, alpha: 1).cgColor,
            UIColor(red: 0.93, green: 0.85, blue: 0.67, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupViews() {
        titleLabel.text = "Expedition Journal"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }
        filterSegment.selectedSegmentIndex = 0
        filterSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        view.addSubview(filterSegment)
        filterSegment.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
        }
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(JournalEventCell.self, forCellReuseIdentifier: "JournalEventCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterSegment.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-120)
        }
        exportButton.setTitle("Export Journal", for: .normal)
        exportButton.setTitleColor(.white, for: .normal)
        exportButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        exportButton.backgroundColor = UIColor(red: 0.72, green: 0.54, blue: 0.32, alpha: 1)
        exportButton.layer.cornerRadius = 18
        exportButton.addTarget(self, action: #selector(exportJournal), for: .touchUpInside)
        view.addSubview(exportButton)
        exportButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(44)
        }
        quoteLabel.font = .italicSystemFont(ofSize: 16)
        quoteLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 0.8)
        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 0
        view.addSubview(quoteLabel)
        quoteLabel.snp.makeConstraints { make in
            make.bottom.equalTo(exportButton.snp.top).offset(-16)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func showRandomQuote() {
        quoteLabel.text = quotes.randomElement()
    }
    
    private func loadJournal() {
        events.removeAll()
        let artifacts = UserDefaults.standard.stringArray(forKey: "foundArtifacts") ?? []
        let bestMoves = UserDefaults.standard.integer(forKey: "bestMatchMoves")
        for emoji in artifacts {
            events.append(JournalEvent(type: .artifact, text: "Discovered artifact: \(emoji)", emoji: emoji))
        }
        if bestMoves > 0 {
            events.append(JournalEvent(type: .record, text: "Best match game: \(bestMoves) moves", emoji: "🏆"))
        }
        // Добавим достижения
        if artifacts.count >= 20 {
            events.append(JournalEvent(type: .achievement, text: "All artifacts found! Legendary Explorer! 👑", emoji: "👑"))
        } else if artifacts.count >= 10 {
            events.append(JournalEvent(type: .achievement, text: "10+ artifacts found! Collector! 🏆", emoji: "🏆"))
        }
        filteredEvents = events
        tableView.reloadData()
    }
    
    @objc private func filterChanged() {
        switch filterSegment.selectedSegmentIndex {
        case 1:
            filteredEvents = events.filter { $0.type == .artifact }
        case 2:
            filteredEvents = events.filter { $0.type == .record || $0.type == .achievement }
        case 3:
            filteredEvents = [JournalEvent(type: .quote, text: quotes.randomElement() ?? "", emoji: "📜")]
        default:
            filteredEvents = events
        }
        tableView.reloadData()
    }
    
    @objc private func exportJournal() {
        let exportText = events.map { "\($0.emoji) \($0.text)" }.joined(separator: "\n")
        let activityVC = UIActivityViewController(activityItems: [exportText], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

private enum JournalEventType { case artifact, record, achievement, quote }
private struct JournalEvent {
    let type: JournalEventType
    let text: String
    let emoji: String
}

private class JournalEventCell: UITableViewCell {
    private let emojiLabel = UILabel()
    private let eventLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        emojiLabel.font = .systemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        eventLabel.font = .systemFont(ofSize: 17)
        eventLabel.textColor = UIColor(red: 0.45, green: 0.32, blue: 0.18, alpha: 1)
        eventLabel.numberOfLines = 0
        contentView.addSubview(eventLabel)
        eventLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).offset(8)
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with event: JournalEvent) {
        emojiLabel.text = event.emoji
        eventLabel.text = event.text
    }
}

extension JournalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEventCell", for: indexPath) as! JournalEventCell
        cell.configure(with: filteredEvents[indexPath.row])
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [], animations: {
            cell.alpha = 1
        })
        return cell
    }
} 