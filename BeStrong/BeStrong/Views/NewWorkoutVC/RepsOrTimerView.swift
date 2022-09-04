import UIKit

class RepsOrTimerView: UIView {
    
    private let setsLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countSetsLabel = UILabel(text: "3", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var setsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 6
        slider.value = 3
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(changeSetsSlider), for: .valueChanged)
        return slider
    }()
    
    private let chooseLabel = UILabel(text: "Choose repeat or timer")
    
    private let repsLabel = UILabel(text: "Reps", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countRepsLabel = UILabel(text: "10", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var repsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 6
        slider.maximumValue = 20
        slider.value = 10
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(changeRepsSlider), for: .valueChanged)
        return slider
    }()
    
    private let timerLabel = UILabel(text: "Timer", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countTimerLabel = UILabel(text: "6m: 0s", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var timerSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 50
        slider.value = 25
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialLightBrown
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(changeTimerSlider), for: .valueChanged)
        return slider
    }()
    

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
        
        addSubview(setsLabel)
        addSubview(countSetsLabel)
        addSubview(setsSlider)
        addSubview(chooseLabel)
        addSubview(repsLabel)
        addSubview(countRepsLabel)
        addSubview(repsSlider)
        addSubview(timerLabel)
        addSubview(countTimerLabel)
        addSubview(timerSlider)
    }
    
    @objc private func changeSetsSlider(sender: UISlider) {
        let step: Float = 1
        let currentValue = round((sender.value - sender.minimumValue) / step) + sender.minimumValue
        print(sender.value)
        countSetsLabel.text = String(format: "%.0f", currentValue)
    }
    
    @objc private func changeRepsSlider(sender: UISlider) {
        let step: Float = 1
        let currentValue = round((sender.value - sender.minimumValue) / step) + sender.minimumValue
        print(currentValue)
        countRepsLabel.text = String(format: "%.0f", currentValue)
    }
    
    @objc private func changeTimerSlider(sender: UISlider) {
        
        let countSec = Int(Double(sender.value) * 14.4)
        let minutes: Int = countSec / 60
        let seconds = countSec - (minutes * 60)
        print(sender.value)
        countTimerLabel.text = "\(minutes)m: \(seconds)s"
    }
}

//MARK: - Set Constraints

extension RepsOrTimerView {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            setsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            setsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            countSetsLabel.centerYAnchor.constraint(equalTo: setsLabel.centerYAnchor),
            countSetsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            setsSlider.topAnchor.constraint(equalTo: setsLabel.bottomAnchor, constant: 5),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            chooseLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            chooseLabel.topAnchor.constraint(equalTo: setsSlider.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            repsLabel.topAnchor.constraint(equalTo: chooseLabel.bottomAnchor, constant: 20),
            repsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            countRepsLabel.centerYAnchor.constraint(equalTo: repsLabel.centerYAnchor),
            countRepsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            repsSlider.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: 5),
            repsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: repsSlider.bottomAnchor, constant: 20),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            countTimerLabel.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor),
            countTimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            timerSlider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 5),
            timerSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timerSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
