import UIKit

class DetailsWithTimerView: UIView {
    
    private let workoutName = UILabel(text: "Squats", font: .robotoMedium24(), textColor: .specialGray)
    
    private let setsLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    
    private let setsProgressLabel = UILabel(text: "1/4", font: .robotoMedium24(), textColor: .specialGray)
    
    private let firstSeparatingView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerLabel = UILabel(text: "Time of Set", font: .robotoMedium18(), textColor: .specialGray)
    
    private let timerProgressLabel = UILabel(text: "1 min 30 sec", font: .robotoMedium24(), textColor: .specialGray)
    
    private let secondSeparatingView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLightBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium16()
        button.setImage(UIImage(named: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(editingButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("NEXT SET", for: .normal)
        button.tintColor = .specialGray
        button.titleLabel?.font = .robotoMedium16()
        button.addTarget(self, action: #selector(nextSetButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var firstLineStackView = UIStackView()
    private var secondLineStackView = UIStackView()
    
    weak var detailsWithTimerViewDelegate: DetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(workoutName)
        firstLineStackView = UIStackView(arrangedSubviews: [setsLabel,
                                                            setsProgressLabel],
                                         axis: .horizontal,
                                         spacing: 10)
        firstLineStackView.distribution = .equalSpacing
        addSubview(firstLineStackView)
        addSubview(firstSeparatingView)
    
        secondLineStackView = UIStackView(arrangedSubviews: [timerLabel,
                                                             timerProgressLabel],
                                          axis: .horizontal,
                                          spacing: 10)
        secondLineStackView.distribution = .equalSpacing
        addSubview(secondLineStackView)
        addSubview(secondSeparatingView)
        addSubview(editingButton)
        addSubview(nextSetButton)
    }
    
    @objc private func editingButtonPressed() {
        detailsWithTimerViewDelegate?.editingButtonPressed()
    }
    
    
    @objc private func nextSetButtonPressed() {
        detailsWithTimerViewDelegate?.nextButtonPressed()
    }
}

//MARK: - Set Constraints

extension DetailsWithTimerView {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            workoutName.centerXAnchor.constraint(equalTo: centerXAnchor),
            workoutName.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            firstLineStackView.topAnchor.constraint(equalTo: workoutName.bottomAnchor, constant: 15),
            firstLineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            firstLineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            firstSeparatingView.topAnchor.constraint(equalTo: firstLineStackView.bottomAnchor, constant: 3),
            firstSeparatingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            firstSeparatingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            firstSeparatingView.heightAnchor.constraint(equalToConstant: 1)
        ])

        NSLayoutConstraint.activate([
            secondLineStackView.topAnchor.constraint(equalTo: firstSeparatingView.bottomAnchor, constant: 15),
            secondLineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            secondLineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            secondSeparatingView.topAnchor.constraint(equalTo: secondLineStackView.bottomAnchor, constant: 3),
            secondSeparatingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            secondSeparatingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            secondSeparatingView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            editingButton.topAnchor.constraint(equalTo: secondSeparatingView.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            editingButton.heightAnchor.constraint(equalToConstant: 25),
            editingButton.widthAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 10),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nextSetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
}
