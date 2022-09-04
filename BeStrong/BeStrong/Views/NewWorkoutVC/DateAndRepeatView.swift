import UIKit

class DateAndRepeatView: UIView {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .robotoMedium18()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .specialGreen
        datePicker.subviews[0].subviews[0].subviews[0].alpha = 0
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat every 7 days"
        label.font = .robotoMedium18()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = true
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    private var firstLineStackView = UIStackView()
    private var secondLineStackView = UIStackView()
    
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
        
        firstLineStackView = UIStackView(arrangedSubviews: [dateLabel,
                                                            datePicker],
                                         axis: .horizontal,
                                         spacing: 10)
        firstLineStackView.distribution = .equalSpacing
        
        secondLineStackView = UIStackView(arrangedSubviews: [repeatLabel,
                                                             repeatSwitch],
                                          axis: .horizontal,
                                          spacing: 10)
        secondLineStackView.distribution = .equalSpacing
        
        addSubview(firstLineStackView)
        addSubview(secondLineStackView)
    }
    
    private func getDateAndReapete() -> (Date, Bool) {
        (datePicker.date, repeatSwitch.isOn)
    }
    
    public func setDateAndRepeat() -> (Date, Bool) {
        getDateAndReapete()
    }
}

//MARK: - Set Constraints

extension DateAndRepeatView {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            firstLineStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            firstLineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            firstLineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            secondLineStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            secondLineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            secondLineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
