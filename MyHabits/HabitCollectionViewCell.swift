import UIKit

class HabitCollectionViewCell: UICollectionViewCell {

    static let ID = "HabitCollectionViewCell_ReuseID"

    var habit: Habit!

    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var habitNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 17)
        label.text = "Без названия"
        return label
    }()

    private lazy var habitTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontNames.SFProTextRegular, size: 12)
        label.text = "Каждый день в 0:00"
        label.textColor = .systemGray2
        return label
    }()

    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 13)
        label.text = "Счётчик: 0"
        label.textColor = .systemGray
        return label
    }()

    private lazy var statusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "CheckMark"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayouts()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(habitNameLabel)
        mainView.addSubview(habitTimeLabel)
        mainView.addSubview(counterLabel)
        mainView.addSubview(statusButton)
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            habitNameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            habitNameLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            habitTimeLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 8),
            habitTimeLabel.leftAnchor.constraint(equalTo: habitNameLabel.leftAnchor),

            counterLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),
            counterLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),

            statusButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            statusButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24),
            statusButton.heightAnchor.constraint(equalToConstant: 40),
            statusButton.widthAnchor.constraint(equalToConstant: 40)

        ])
    }

    private func setupActions() {
        statusButton.addTarget(
            self,
            action: #selector(statusButtonPressed(_:)),
            for: .touchUpInside
        )
    }

    func update(_ habit: Habit) {
        self.habit = habit
        habitNameLabel.text = habit.name
        habitNameLabel.textColor = habit.color
        habitTimeLabel.text = habit.dateString
        statusButton.layer.borderColor = habit.color.cgColor
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        if habit.isAlreadyTakenToday {
            statusButton.backgroundColor = habit.color
        } else {
            statusButton.backgroundColor = .white
        }
        
    }

    @objc private func statusButtonPressed(_ sender: UIButton) {
        if !habit.isAlreadyTakenToday {
            HabitsStore.shared.track(habit)
            counterLabel.text = "Счётчик: \(habit.trackDates.count)"
            statusButton.backgroundColor = habit.color

            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "updateCollectionView"),
                object: nil
            )
        }
    }
}
