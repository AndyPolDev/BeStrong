import UIKit

class ExercisesTableViewCell: UITableViewCell {
    
    private let exerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "Biceps"
        label.textColor = .specialGray
        label.font = .robotoBold24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previousResultLabel = UILabel(text: "Before: 18")
    
    private let currentResultLabel = UILabel(text: "Now: 20")

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "+2"
        label.textColor = .specialGreen
        label.font = .robotoBold24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(exerciseLabel)
        
        labelStackView = UIStackView(arrangedSubviews: [previousResultLabel,
                                                        currentResultLabel
                                                       ], axis: .horizontal, spacing: 10)
        addSubview(labelStackView)
        addSubview(progressLabel)
        addSubview(separatorView)
    }
}

//MARK: - Set Constraints

extension ExercisesTableViewCell {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            exerciseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 0),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
