import UIKit

class DateTableViewCell: UITableViewCell {

    static let ID = "DateTableViewCell_ReuseID"

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontNames.SFProTextRegular, size: 17)
        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        addSubviews()
        tuneView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(dateLabel)
    }

    private func tuneView() {

    }

    private func setupConstraints() {
        let heightConstraint = dateLabel.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            heightConstraint
        ])
    }

    func update(_ habit: Habit, _ date: Date) {
        let dateMinus1Day = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateMinus2Days = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM")

        if dateFormatter.string(from: Date()) == dateFormatter.string(from: date) {
            dateLabel.text = "Сегодня"
        } else if dateFormatter.string(from: dateMinus1Day) == dateFormatter.string(from: date) {
            dateLabel.text = "Вчера"
        } else if dateFormatter.string(from: dateMinus2Days) == dateFormatter.string(from: date) {
            dateLabel.text = "Позавчера"
        } else {
            dateLabel.text = dateFormatter.string(from: date)
        }

        if HabitsStore.shared.habit(habit, isTrackedIn: date) {
            accessoryType = .checkmark
        }
    }
}
