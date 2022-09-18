import UIKit
import RealmSwift

class StatisticViewController: UIViewController {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTICS"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exercisesLabel = UILabel(text: "Exercises")
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font  = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.white],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.specialGray],
                                                for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let idStatisticTableViewCell = "idStatisticTableViewCell"
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>?
    
    private var differenceArray = [DifferenceWorkout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        differenceArray = [DifferenceWorkout]()
        setStartScreen()
        tableView.reloadData()
    }
    
    private func setViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(mainLabel)
        view.addSubview(exercisesLabel)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        tableView.register(ExercisesTableViewCell.self, forCellReuseIdentifier: idStatisticTableViewCell)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getWorkoutsName() -> [String] {
        
        var nameArray = [String]()
        
        let workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutsName()
        
        for name in nameArray {
            
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            
            guard let lastReps = workoutArray?.last?.workoutReps,
                  let firstReps = workoutArray?.first?.workoutReps,
                  let lastTime = workoutArray?.last?.workoutTimer,
                  let firstTime = workoutArray?.first?.workoutTimer else {
                return
            }
        
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: lastReps, firstReps: firstReps, lastTime: lastTime, firstTime: firstTime)
            differenceArray.append(differenceWorkout)
        }
    }
    
    private func setStartScreen() {
        let dateToday = Date().localDate()
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
    }
    
    @objc private func segmentedChanged() {
        let dateToday = Date().localDate()
        differenceArray = [DifferenceWorkout]()
    
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        tableView.reloadData()
    }
}
    
    //MARK: - UICollectionViewDataSource
    
    extension StatisticViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            differenceArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: idStatisticTableViewCell, for: indexPath) as? ExercisesTableViewCell else {
                return UITableViewCell()
            }
            
            let differenceModel = differenceArray[indexPath.row]
            cell.cellConfigure(differenseWorkout: differenceModel)
            
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    
    extension StatisticViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            65
        }
    }
    
    //MARK: - Set Constraints
    
    extension StatisticViewController {
        private func setConstraints() {
            
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
            
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 30),
                segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
            
            NSLayoutConstraint.activate([
                exercisesLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
                exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
    }
