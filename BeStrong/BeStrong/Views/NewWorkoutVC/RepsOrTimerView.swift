import UIKit

class RepsOrTimerView: UIView {
    
    private let setsLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countSetsLabel = UILabel(text: "0", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var setsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 6
        slider.value = 0
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(setsSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let chooseLabel = UILabel(text: "Choose repeat or timer")
    
    private let repsLabel = UILabel(text: "Reps", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countRepsLabel = UILabel(text: "0", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var repsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 20
        slider.value = 0
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(repsSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let timerLabel = UILabel(text: "Timer", font: .robotoMedium18(), textColor: .specialGray)
    
    private var countTimerLabel = UILabel(text: "0 sec", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var timerSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1200
        slider.value = 0
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(timerSliderChanged), for: .valueChanged)
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
    
    @objc private func setsSliderChanged(sender: UISlider) {
        countSetsLabel.text = "\(Int(sender.value))"
    }
    
    @objc private func repsSliderChanged(sender: UISlider) {
        countRepsLabel.text = "\(Int(sender.value))"
        
        setNegative(label: timerLabel, numberLabel: countTimerLabel, slider: timerSlider)
        setActive(label: repsLabel, numberLabel: countRepsLabel, slider: repsSlider)
    }
    
    @objc private func timerSliderChanged(sender: UISlider) {
        let (min, sec) = { (secs: Int) -> (Int, Int) in
            return (secs / 60, secs % 60)}(Int(sender.value))
        
        //countTimerLabel.text = (sec != 0 ? "\(min) min \(sec) sec" : "\(min) min")
        
        if min == 0 {
            countTimerLabel.text = "\(sec) sec"
        } else if sec == 0 {
            countTimerLabel.text = "\(min) min"
        } else {
            countTimerLabel.text = "\(min) min \(sec) sec"
        }
        
        setNegative(label: repsLabel, numberLabel: countRepsLabel, slider: repsSlider)
        setActive(label: timerLabel, numberLabel: countTimerLabel, slider: timerSlider)
    }
    
    private func setNegative(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 0.5
        numberLabel.alpha = 0.5
        numberLabel.text = "0"
        slider.alpha = 0.5
        slider.value = 0
    }
    
    private func setActive(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 1
        numberLabel.alpha = 1
        slider.alpha = 1
    }
    
    private func getSliderValue() -> (Int, Int, Int) {
        let setsSliderValue = Int(setsSlider.value)
        let repsSliderValue = Int(repsSlider.value)
        let timerSliderValue = Int(timerSlider.value)
        
        return (setsSliderValue, repsSliderValue, timerSliderValue)
    }
    
    internal func setSliderValue() -> (Int, Int, Int) {
        getSliderValue()
    }
    
    private func refreshWorkoutObjects() {
        countSetsLabel.text = "0"
        setsSlider.value = 0
        countRepsLabel.text = "0"
        repsSlider.value = 0
        countTimerLabel.text = "0 sec"
        timerSlider.value = 0
    }
    
    internal func refreshLabelsAndSliders() {
        refreshWorkoutObjects()
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
