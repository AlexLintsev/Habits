import UIKit

class InfoViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "\nПривычка за 21 день\n"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return titleLabel
    }()

    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля.\n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги - что оказалось тяжело, что - легче, с чем еще предстоит серьезно бороться.\n\n4. Поздравь себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\n\n6. На 90-й день соблюдения техники все лишнее из \"прошлой жизни\" перестают напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n\nИсточник: psychbook.ru"
        mainLabel.numberOfLines = 0
        return mainLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        tuneView()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(mainLabel)
    }

    private func setupConstraints() {

        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            mainLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            mainLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            mainLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            mainLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            mainLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

        ])
    }

    private func tuneView() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "Информация"

        let tabBarItem = UITabBarItem()
        tabBarItem.title = "Информация"
        tabBarItem.image = UIImage(named: "Info")
        tabBarItem.imageInsets = UIEdgeInsets(
            top: 30,
            left: 30,
            bottom: 30,
            right: 30
        )
        self.tabBarItem = tabBarItem


    }

}
