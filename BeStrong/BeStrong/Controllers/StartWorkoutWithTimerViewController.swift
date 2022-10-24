import UIKit

class StartWorkoutWithTimerViewController: UIViewController {
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let ellipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1:35"
        label.textColor = .specialGray
        label.font = .robotoBold48()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let detailsView = DetailsWithTimerView()
    
    private lazy var finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoMedium16()
        button.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var workoutModel = WorkoutModel()
    
    private let customAlert = CustomAlert()
    
    private var durationTimer = 0
    private var numberOfSet = 0
    private var shapeLayer = CAShapeLayer()
    private var timer = Timer()
    private var tapLabel = UIGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setDelegates()
        setConstraints()
        addTaps()
        setWorkoutParameters()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        animationCircular()
    }
    
    private func setViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(ellipseImageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(detailsView)
        view.addSubview(finishButton)
    }
    
    private func setDelegates() {
        detailsView.detailsWithTimerViewDelegate = self
    }
    
    private func addTaps() {
        tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
        tapLabel.isEnabled = true
    }
    
    private func setWorkoutParameters() {
        detailsView.workoutName.text = workoutModel.workoutName
        detailsView.setsProgressLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let(min, sec) = workoutModel.workoutTimer.convertSeconds()
        detailsView.timerProgressLabel.text = "\(min) min \(sec) sec"
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
        
        durationTimer = workoutModel.workoutTimer
    }
    
    @objc private func closeButtonPressed() {
        timer.invalidate()
        dismiss(animated: true)
    }
    
    @objc private func finishButtonPressed() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            alertOkCancel(title: "Warning",
                          message: "You haven't finished your workout") {
                self.timer.invalidate()
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func startTimer() {
        detailsView.editingButton.isEnabled = false
        detailsView.nextSetButton.isEnabled = false
        tapLabel.isEnabled = false
        
        if numberOfSet == workoutModel.workoutSets {
            alertOK(title: "Error", messoge: "Finish your workout")
            tapLabel.isEnabled = true
        } else {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            detailsView.setsProgressLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            detailsView.editingButton.isEnabled = true
            detailsView.nextSetButton.isEnabled = true
            tapLabel.isEnabled = true
        }
        
        let (min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
    }
}

//MARK: - Animation

extension StartWorkoutWithTimerViewController {
    
    private func animationCircular() {
        let center = CGPoint(x: ellipseImageView.frame.width / 2,
                             y: ellipseImageView.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: view.frame.width * 0.7 / 2 - 21 / 2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}


//MARK: - DetailViewDelegate

extension StartWorkoutWithTimerViewController: DetailViewDelegate {
    func editingButtonPressed() {
        customAlert.alertCustom(viewController: self, repsOrTimer: "Time of set") { [self] sets, timerOfSet in
            if sets != "" && timerOfSet != "" {
                guard let numberOfSets = Int(sets) else { return }
                guard let numberOfTimer = Int(timerOfSet) else { return }
                
                let (min, sec) = numberOfTimer.convertSeconds()
                
                detailsView.setsProgressLabel.text = "\(numberOfSet)/\(sets)"
                detailsView.timerProgressLabel.text = "\(min) min \(sec) sec"
                timerLabel.text = "\(min):\(sec.setZeroForSecond())"
                durationTimer = numberOfTimer
                
                RealmManager.shared.updateSetsTimerWorkoutModel(model: workoutModel,
                                                                sets: numberOfSets,
                                                                timer: numberOfTimer)
            }
        }
    }
    
    func nextButtonPressed() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            detailsView.setsProgressLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOK(title: "Error", messoge: "Finish your workout")
        }
    }
}

//MARK: - Set Constraints

extension StartWorkoutWithTimerViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: ellipseImageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: ellipseImageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 25),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 3),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsView.heightAnchor.constraint(equalToConstant: 235)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 25),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
