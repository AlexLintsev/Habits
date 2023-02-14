import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    static let ID = "ProgressCollectionViewCell_ReuseID"

    private var statusBarConstraint: NSLayoutConstraint!

    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var statusTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Всё получится!"
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 13)
        label.textColor = UIColor.systemGray
        return label
    }()

    private lazy var statusPercentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 13)
        label.textColor = UIColor.systemGray
        return label
    }()

    private lazy var generalStatusBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 3
        return view
    }()

    private lazy var currentStatusBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.main)
        view.layer.cornerRadius = 3
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(statusTextLabel)
        mainView.addSubview(statusPercentLabel)
        mainView.addSubview(generalStatusBarView)
        mainView.addSubview(currentStatusBarView)
    }

    private func setupLayouts() {

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            statusTextLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),
            statusTextLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 8),

            statusPercentLabel.topAnchor.constraint(equalTo: statusTextLabel.topAnchor),
            statusPercentLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -8),

            generalStatusBarView.topAnchor.constraint(equalTo: statusTextLabel.bottomAnchor, constant: 8),
            generalStatusBarView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 8),
            generalStatusBarView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -8),
            generalStatusBarView.heightAnchor.constraint(equalToConstant: 6),

            currentStatusBarView.topAnchor.constraint(equalTo: generalStatusBarView.topAnchor),
            currentStatusBarView.leftAnchor.constraint(equalTo: generalStatusBarView.leftAnchor),
            currentStatusBarView.bottomAnchor.constraint(equalTo: generalStatusBarView.bottomAnchor)
        ])
    }

    func update() {
        let barProgress = HabitsStore.shared.todayProgress
        let barWitdth = self.frame.width - 16
        if statusBarConstraint != nil {
            statusBarConstraint.isActive = false
        }
        statusBarConstraint = currentStatusBarView.widthAnchor.constraint(equalToConstant: barWitdth * CGFloat(barProgress))
        statusBarConstraint.isActive = true

        statusPercentLabel.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
    }
}
