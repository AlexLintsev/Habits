import UIKit

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {

    private var habit: Habit?

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()

    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 17)
        return label
    }()

    private lazy var habitNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont(name: FontNames.SFProTextSemibold, size: 17)
        field.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        field.textColor = UIColor(named: ColorNames.blue)
        return field
    }()

    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 17)
        return label
    }()

    private lazy var setColorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: ColorNames.orange)
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.font = UIFont(name: FontNames.SFProTextSemibold, size: 17)
        return label
    }()

    private lazy var leftPartHabitTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в "
        label.font = UIFont(name: FontNames.SFProTextRegular, size: 17)
        return label
    }()

    private lazy var rightPartHabitTimeLabel: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontNames.SFProTextRegular, size: 17)
        label.textColor = UIColor(named: ColorNames.main)

        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")

        label.text = "\(dateFormatter.string(from: timePickerView.date))"

        return label
    }()

    private lazy var timePickerView: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        return timePicker
    }()

    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: FontNames.SFProTextRegular, size: 17)
        return button
    }()

    init(with habit: Habit?) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        tuneView()
        setupConstraints()
        setupActions()
    }

    private func addSubViews() {
        view.addSubview(separatorView)
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(habitNameTextField)
        mainView.addSubview(colorLabel)
        mainView.addSubview(setColorButton)
        mainView.addSubview(timeLabel)
        mainView.addSubview(leftPartHabitTimeLabel)
        mainView.addSubview(rightPartHabitTimeLabel)
        mainView.addSubview(timePickerView)
        if habit != nil {
            mainView.addSubview(deleteHabitButton)
        }
    }

    private func tuneView() {
        view.backgroundColor = UIColor(named: ColorNames.lightGray)

        if let habit {
            navigationItem.title = "Править"
            habitNameTextField.text = habit.name
            setColorButton.backgroundColor = habit.color
            timePickerView.date = habit.date

            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")

            rightPartHabitTimeLabel.text = "\(dateFormatter.string(from: timePickerView.date))"
        } else {
            navigationItem.title = "Создать"
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancelButtonPressed(_:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveButtonPressed(_:)))

        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: ColorNames.main)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.main)

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextRegular, size: 17)!]
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextRegular, size: 17)!],
            for: UIControl.State.normal
        )
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name: FontNames.SFProTextSemibold, size: 17)!],
            for: UIControl.State.normal
        )
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            separatorView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            mainView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 32),
            titleLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            habitNameTextField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),
            habitNameTextField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),

            colorLabel.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 16),
            colorLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            setColorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 8),
            setColorButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),
            setColorButton.widthAnchor.constraint(equalToConstant: 32),
            setColorButton.heightAnchor.constraint(equalToConstant: 32),

            timeLabel.topAnchor.constraint(equalTo: setColorButton.bottomAnchor, constant: 16),
            timeLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            leftPartHabitTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            leftPartHabitTimeLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),

            rightPartHabitTimeLabel.topAnchor.constraint(equalTo: leftPartHabitTimeLabel.topAnchor),
            rightPartHabitTimeLabel.leftAnchor.constraint(equalTo: leftPartHabitTimeLabel.rightAnchor),

            timePickerView.topAnchor.constraint(equalTo: leftPartHabitTimeLabel.bottomAnchor, constant: 8),
            timePickerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
        ])

        if habit != nil {
            NSLayoutConstraint.activate([
                deleteHabitButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -16),
                deleteHabitButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor)
            ])
        }
    }

    private func setupActions() {
        setColorButton.addTarget(
            self,
            action: #selector(setColorButtonPressed(_:)),
            for: .touchUpInside
        )

        timePickerView.addTarget(
            self,
            action: #selector(timePickerViewChanged(_:)),
            for: .valueChanged)

        if habit != nil {
            deleteHabitButton.addTarget(
                self,
                action: #selector(deleteHabitButtonPressed(_:)),
                for: .touchUpInside
            )
        }
    }


    @objc private func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @objc private func saveButtonPressed(_ sender: UIButton) {
        let store = HabitsStore.shared

        if let habit {
            var habitForModify = store.habits.first(where: { habit == $0 })!
            habitForModify.name = habitNameTextField.text!.isEmpty ? "Без названия" : habitNameTextField.text!
            habitForModify.date = timePickerView.date
            habitForModify.color = setColorButton.backgroundColor!
        } else {
            let newHabit = Habit(
                name: habitNameTextField.text!.isEmpty ? "Без названия" : habitNameTextField.text!,
                date: timePickerView.date,
                color: setColorButton.backgroundColor!
            )
            store.habits.append(newHabit)
        }

        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "updateCollectionView"),
            object: nil
        )
        
        self.dismiss(animated: true)
    }

    @objc private func deleteHabitButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \(habit!.name)?",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Отмена", comment: "Отменить удаление привычки"),
                style: .default,
                handler: .none
            ))
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Удалить", comment: "Удалить привычку"),
                style: .destructive,
                handler: { _ in
                    HabitsStore.shared.habits.remove(at: HabitsStore.shared.habits.firstIndex(of: self.habit!)!)
                    NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: "updateCollectionView"),
                        object: nil
                    )
                    self.dismiss(animated: true)
                }
            ))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func setColorButtonPressed(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.delegate = self
        colorPickerViewController.selectedColor = setColorButton.backgroundColor!
        present(colorPickerViewController, animated: true)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        setColorButton.backgroundColor = viewController.selectedColor
    }

    @objc private func timePickerViewChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
        rightPartHabitTimeLabel.text = "\(dateFormatter.string(from: timePickerView.date))"
    }
}
