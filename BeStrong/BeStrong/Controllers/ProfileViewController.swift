import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    private let editingProfileLabel = UILabel(text: "PROFILE", font: .robotoMedium24(), textColor: .specialGray)
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(rgb: 0xC2C2C2)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "parrot")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userPhotoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userNameLabel = UILabel(text: "Unknown", font: .robotoBold24(), textColor: .white)
    
    private let heightLabel = UILabel(text: "Height:", font: .robotoBold16(), textColor: .specialGray)
    private let weightLabel = UILabel(text: "Weight:", font: .robotoBold16(), textColor: .specialGray)
    private var labelStackView = UIStackView()
    
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Editing ", for: .normal)
        button.tintColor = .specialGreen
        button.titleLabel?.font = .robotoBold16()
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.addTarget(self, action: #selector(editingButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressCollectionView = ProgressView()
//
//    private let targetLabel = UILabel(text: "TARGET:", font: .robotoBold16(), textColor: .specialGray)
//
//    private let currentProgressLabel = UILabel(text: "2", font: .robotoBold24(), textColor: .specialGray)
//    private let goalLabel = UILabel(text: "20", font: .robotoBold24(), textColor: .specialGray)
    
//    private let progressView: UIProgressView = {
//        let progressView = UIProgressView()
//        progressView.trackTintColor = .specialBrown
//        progressView.progressTintColor = .specialGreen
//        progressView.setProgress(0.2, animated: true)
//        progressView.clipsToBounds = true
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        return progressView
//    }()
//
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>!
    private var userArray: Results<UserModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        
        setupViews()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        workoutArray = localRealm.objects(WorkoutModel.self)
        progressCollectionView.configureProgressCollectionView(model: workoutArray)
        setupUserParameters()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        //progressView.layer.cornerRadius = progressView.frame.height / 2
        
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(editingProfileLabel)
        view.addSubview(userPhotoBackgroundView)
        view.addSubview(userPhoto)
        view.addSubview(userNameLabel)
        labelStackView = UIStackView(arrangedSubviews: [heightLabel, weightLabel],
                                     axis: .horizontal,
                                     spacing: 10)
        view.addSubview(labelStackView)
        view.addSubview(editingButton)
        view.addSubview(progressCollectionView)
//        view.addSubview(targetLabel)
//        view.addSubview(currentProgressLabel)
//        view.addSubview(goalLabel)
//        view.addSubview(progressView)
        
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            heightLabel.text = "Height: \(userArray[0].userHeight)"
            weightLabel.text = "Weight: \(userArray[0].userWeight)"
//            targetLabel.text = "Target: \(userArray[0].userTarget)"
//            goalLabel.text = "\(userArray[0].userTarget)"
            
            guard let imageData = userArray[0].userImage else { return }
            userPhoto.image = UIImage(data: imageData)
            userPhoto.contentMode = .scaleAspectFit
        }
    }
    
    @objc private func editingButtonPressed() {
        let newWorkoutViewController = EditingProfileViewController()
        newWorkoutViewController.modalPresentationStyle = .fullScreen
        newWorkoutViewController.modalTransitionStyle = .coverVertical
        present(newWorkoutViewController, animated: true)
    }
}

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            editingProfileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editingProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: editingProfileLabel.bottomAnchor, constant: 10),
            userPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhoto.heightAnchor.constraint(equalToConstant: 100),
            userPhoto.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoBackgroundView.topAnchor.constraint(equalTo: userPhoto.topAnchor, constant: 50),
            userPhotoBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userPhotoBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userPhotoBackgroundView.heightAnchor.constraint(equalToConstant: 112)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.centerXAnchor.constraint(equalTo: userPhotoBackgroundView.centerXAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelStackView.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editingButton.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            progressCollectionView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 20),
            progressCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
//        NSLayoutConstraint.activate([
//            targetLabel.topAnchor.constraint(equalTo: progressCollectionView.bottomAnchor, constant: 10),
//            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
//        ])
//
//        NSLayoutConstraint.activate([
//            currentProgressLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 0),
//            currentProgressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
//        ])
//
//        NSLayoutConstraint.activate([
//            goalLabel.centerYAnchor.constraint(equalTo: currentProgressLabel.centerYAnchor),
//            goalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
//        ])
//
//        NSLayoutConstraint.activate([
//            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            progressView.topAnchor.constraint(equalTo: currentProgressLabel.bottomAnchor, constant: 5),
//            progressView.heightAnchor.constraint(equalToConstant: 30)
//        ])
        
    }
}
