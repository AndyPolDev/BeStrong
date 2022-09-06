import UIKit

class StartWorkoutWithRepsViewController: UIViewController {
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        //
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let ladyWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ladyWorkout")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let detailsView = DetailsWithRepsView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    }
    
    private func setViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(ladyWorkoutImageView)
        view.addSubview(detailsLabel)
        view.addSubview(detailsView)
        view.addSubview(finishButton)
    }
    
    @objc private func closeButtonPressed() {
        print("Close button pressed")
    }
    
    @objc private func finishButtonPressed() {
        print("Finish button pressed")
    }
}

//MARK: - Set Constraints

extension StartWorkoutWithRepsViewController {
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
            ladyWorkoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ladyWorkoutImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 25),
            ladyWorkoutImageView.widthAnchor.constraint(equalToConstant: 190),
            ladyWorkoutImageView.heightAnchor.constraint(equalToConstant: 250)
        ])

        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ladyWorkoutImageView.bottomAnchor, constant: 25),
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

