import UIKit

class HabitsViewController: UIViewController {

    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        label.font = UIFont(name: FontNames.SFProDisplaySemibold, size: 36)
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(
            frame: .null,
            collectionViewLayout: viewLayout
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.lightGray)
        view.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: ProgressCollectionViewCell.ID
        )
        view.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: HabitCollectionViewCell.ID
        )
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        tuneView()
        setupConstraints()
    }

    private func setupSubViews() {
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        view.addSubview(separatorView)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func tuneView() {
        view.backgroundColor = .white
        let tabBarItem = UITabBarItem()
        tabBarItem.title = "Привычки"
        tabBarItem.image = UIImage(named: "Habits")
        tabBarItem.imageInsets = UIEdgeInsets(
            top: 30,
            left: 30,
            bottom: 30,
            right: 30
        )
        self.tabBarItem = tabBarItem

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed(_:)))

        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.main)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCollectionView(_:)),
            name: NSNotification.Name(rawValue: "updateCollectionView"),
            object: nil
        )
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            titleView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -16),

            separatorView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            separatorView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            collectionView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)

        ])
    }

    @objc private func updateCollectionView(_ notification: NSNotification) {
        collectionView.reloadData()
    }

    @objc private func addButtonPressed(_ sender: UIButton) {
        let habitViewController = HabitViewController()
        let habitNavigationController = UINavigationController(rootViewController: habitViewController)

        habitNavigationController.modalPresentationStyle = .fullScreen
        habitNavigationController.modalTransitionStyle = .coverVertical
        
        present(habitNavigationController, animated: true)
    }

}

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return 1
        } else {
            let store = HabitsStore.shared
            return store.habits.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProgressCollectionViewCell.ID,
                for: indexPath
            ) as! ProgressCollectionViewCell
            cell.update()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HabitCollectionViewCell.ID,
                for: indexPath
            ) as! HabitCollectionViewCell
            cell.update(HabitsStore.shared.habits[indexPath.row])
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let habitCell = collectionView.cellForItem(at: indexPath) as? HabitCollectionViewCell else { return }
        let habit = habitCell.habit!
        navigationController?.pushViewController(HabitDetailsViewController(habit), animated: true)
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: view.frame.width - 32,
            height: indexPath.section == 0 ? 50 : 130
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 24,
            left: 16,
            bottom: 0,
            right: 16
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
}
