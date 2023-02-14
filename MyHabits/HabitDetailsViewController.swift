import UIKit

class HabitDetailsViewController: UIViewController {

    private var habit: Habit

    private lazy var separatorView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var separatorView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var separatorView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.lightGray)
        return view
    }()

    private lazy var activitylabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "АКТИВНОСТЬ"
        label.font = UIFont(name: FontNames.SFProTextRegular, size: 13)
        label.textColor = UIColor.systemGray
        return label
    }()

    private lazy var datesTableView: UITableView = {
        let view = UITableView(
            frame: .zero,
            style: .plain
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        tuneView()
        tuneDatesTableView()
        setupConstraints()
    }

    init(_ habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        view.addSubview(separatorView1)
        view.addSubview(mainView)
        mainView.addSubview(activitylabel)
        mainView.addSubview(datesTableView)
        mainView.addSubview(separatorView2)
        mainView.addSubview(separatorView3)
    }

    private func tuneView() {
        view.backgroundColor = .white
        navigationItem.title = habit.name

        let backButton = UIBarButtonItem()
        backButton.title = "Сегодня"
        backButton.tintColor = UIColor(named: ColorNames.main)
        backButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextRegular, size: 17)!],
            for: .normal
        )

        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(editButtonPressed(_:)))

        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.main)

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextRegular, size: 17)!]

        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextRegular, size: 17)!],
            for: UIControl.State.normal
        )
    }

    private func tuneDatesTableView() {
        datesTableView.estimatedRowHeight = 40
        datesTableView.tableFooterView = UIView()

        datesTableView.register(
            DateTableViewCell.self,
            forCellReuseIdentifier: DateTableViewCell.ID
        )

        datesTableView.dataSource = self
        datesTableView.delegate = self
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            separatorView1.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            separatorView1.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            separatorView1.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            separatorView1.heightAnchor.constraint(equalToConstant: 0.5),

            mainView.topAnchor.constraint(equalTo: separatorView1.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            activitylabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 24),
            activitylabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            datesTableView.topAnchor.constraint(equalTo: activitylabel.bottomAnchor, constant: 16),
            datesTableView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            datesTableView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            datesTableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),

            separatorView2.topAnchor.constraint(equalTo: datesTableView.topAnchor),
            separatorView2.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            separatorView2.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            separatorView2.heightAnchor.constraint(equalToConstant: 0.5),

            separatorView3.bottomAnchor.constraint(
                equalTo: datesTableView.topAnchor,
                constant: CGFloat(Double(HabitsStore.shared.dates.count) * 40.5)
            ),
            separatorView3.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            separatorView3.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            separatorView3.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    @objc private func editButtonPressed(_ sender: UIButton) {
        let habitViewController = HabitViewController(with: habit)
        let habitNavigationController = UINavigationController(rootViewController: habitViewController)

        habitNavigationController.modalPresentationStyle = .fullScreen
        habitNavigationController.modalTransitionStyle = .coverVertical

        present(habitNavigationController, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        HabitsStore.shared.dates.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let datesList = HabitsStore.shared.dates
        guard let cell = datesTableView.dequeueReusableCell(
            withIdentifier: DateTableViewCell.ID,
            for: indexPath
        ) as? DateTableViewCell else {
            fatalError("Could not dequeueReusableCell")
        }
        cell.update(habit, datesList[datesList.count - 1 - indexPath.row])
        return cell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {

}
