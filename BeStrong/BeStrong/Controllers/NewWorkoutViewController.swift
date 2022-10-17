import UIKit

class NewWorkoutViewController: UIViewController {
    
    private let newWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel = UILabel(text: "Name")
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 15,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat")
    
    private let dateAndRepeatView = DateAndRepeatView()
    
    private let repsOrTimerLabel = UILabel(text: "Reps or timer")
    
    private let repsOrTimerView = RepsOrTimerView()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("SAVE", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoMedium16()
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var workoutModel = WorkoutModel()
    
    private let testImage = UIImage(named: "biceps")
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setDelegate()
        addRecognizers()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    }
    
    private func setViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(dateAndRepeatLabel)
        view.addSubview(dateAndRepeatView)
        view.addSubview(repsOrTimerLabel)
        view.addSubview(repsOrTimerView)
        view.addSubview(saveButton)
    }
    
    private func setDelegate() {
        nameTextField.delegate = self
    }
    
    private func setModel() {
        guard let nameWorkout = nameTextField.text else { return }
        workoutModel.workoutName = nameWorkout
        
        let dateFromPicker = dateAndRepeatView.setDateAndRepeat().0
        workoutModel.workoutDate = dateFromPicker.localDate()
        workoutModel.workoutNumberOfDay = dateFromPicker.getWeekdayNumber()
        workoutModel.workoutRepeat = dateAndRepeatView.setDateAndRepeat().1
        
        workoutModel.workoutSets = repsOrTimerView.setSliderValue().0
        workoutModel.workoutReps = repsOrTimerView.setSliderValue().1
        workoutModel.workoutTimer = repsOrTimerView.setSliderValue().2
        
        guard let imageData = testImage?.pngData() else { return }
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel() {
        guard let text = nameTextField.text else { return }
        let count = text.filter { $0.isNumber || $0.isLetter }.count
        
        if count != 0 &&
            workoutModel.workoutSets != 0 &&
            (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(model: workoutModel)
            createNotifications()
            workoutModel = WorkoutModel()
            alertOK(title: "Success", messoge: nil)
            refreshObjects()
        } else {
            alertOK(title: "Error", messoge: "Please enter all parameters")
        }
    }
    
    private func addRecognizers() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    private func refreshObjects() {
        dateAndRepeatView.refreshDatePickerAndSwitch()
        repsOrTimerView.refreshLabelsAndSliders()
        nameTextField.text = ""
    }
    
    private func createNotifications() {
        let notifications = Notifications()
        let stringDate = workoutModel.workoutDate.ddMMyyyyFromDate()
        notifications.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout" + stringDate)
    }
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        setModel()
        saveModel()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate

extension NewWorkoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}

//MARK: - Set Constraints

extension NewWorkoutViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 3),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            repsOrTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repsOrTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 25),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
