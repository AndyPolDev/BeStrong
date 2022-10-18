import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(rgb: 0xC2C2C2)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your name"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.tintColor = .specialDarkGreen
        button.titleLabel?.font = .robotoMedium12()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 20,
                                              bottom: 15,
                                              right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 50,
                                              left: -40,
                                              bottom: 0,
                                              right: 0)
        button.addShadowOnView()
        button.addTarget(self, action: #selector(addWorkoutButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let workoutTodayLabel = UILabel(text: "Workout Today")
    
    private let noTrainingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noTraining")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    
    private let idWorkoutTableViewCell = "idWorkoutTableViewCell"
    
    private var selectedDate = Date()
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>!
    private var userArray: Results<UserModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupParameters()
        getWorkouts(date: selectedDate)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(calendarView)
        view.addSubview(userPhoto)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        
        view.addSubview(weatherView)
        weatherView.addShadowOnView()
        
        view.addSubview(workoutTodayLabel)
        
        view.addSubview(noTrainingImageView)
        
        view.addSubview(tableView)
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkoutTableViewCell)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        calendarView.cellCollectionViewDelegate = self
        
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let dateStart = date.startEndDate().0
        let dateEnd = date.startEndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnrepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or,
                                           subpredicates: [predicateRepeat, predicateUnrepeat])
        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        
        checkWorkout()
        
        tableView.reloadData()
    }
    
    private func checkWorkout() {
        if workoutArray?.count == 0 {
            noTrainingImageView.isHidden = false
            tableView.isHidden = true
        } else {
            noTrainingImageView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupParameters() {
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            
            guard let imageData = userArray[0].userImage else { return }
            userPhoto.image = UIImage(data: imageData)
        }
    }
    
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onboardingViewed = userDefaults.bool(forKey: "OnboardingViewed")
        if onboardingViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
        }
    }
    
    @objc private func addWorkoutButtonPressed() {
        let newWorkoutViewController = NewWorkoutViewController()
        newWorkoutViewController.modalPresentationStyle = .fullScreen
        newWorkoutViewController.modalTransitionStyle = .coverVertical
        present(newWorkoutViewController, animated: true)
    }
}

//MARK: - SelectCollectionViewItemProtocol

extension MainViewController: SelectCollectionViewItemProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date)
        selectedDate = date
    }
}

//MARK: - StartWorkoutProtocol

extension MainViewController: StartWorkoutProtocol {
    func startButtonPressed(model: WorkoutModel) {
        if model.workoutReps != 0 {
            let startWorkoutWithRepsViewController = StartWorkoutWithRepsViewController()
            startWorkoutWithRepsViewController.modalPresentationStyle = .fullScreen
            startWorkoutWithRepsViewController.workoutModel = model
            present(startWorkoutWithRepsViewController, animated: true)
        } else {
            let startWorkoutWithTimerViewController = StartWorkoutWithTimerViewController()
            startWorkoutWithTimerViewController.modalPresentationStyle = .fullScreen
            startWorkoutWithTimerViewController.workoutModel = model
            present(startWorkoutWithTimerViewController, animated: true)
        }
    }
}



//MARK: - UICollectionViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idWorkoutTableViewCell, for: indexPath) as? WorkoutTableViewCell else {
            return UITableViewCell()
        }
        
        guard let safeModel = workoutArray else { return cell }
        cell.cellConfigure(model: safeModel[indexPath.row])
        cell.cellStartWorkoutDelegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            let deleteModel = self.workoutArray![indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            //tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: - Set Constraints

extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhoto.heightAnchor.constraint(equalToConstant: 100),
            userPhoto.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: userPhoto.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 5),
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            noTrainingImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            noTrainingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noTrainingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noTrainingImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        
        ])
    }
}
