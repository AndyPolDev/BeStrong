import UIKit

class WeatherView: UIView {
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherDiscriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .specialGray
        label.font = .robotoMedium14()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherIconImageView)
        addSubview(cityNameLabel)
        addSubview(weatherDiscriptionLabel)
    }
    
    private func updateLabels(model: WeatherModel) {
        cityNameLabel.text = model.name
        weatherDiscriptionLabel.text = model.weather[0].myDescription + " \(Int(model.main.temp))°C"
    }
    
    private func updateImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        weatherIconImageView.image = image
    }
    
    internal func setWeather (model: WeatherModel) {
        updateLabels(model: model)
    }
    
    internal func setWeatherImage(imageData: Data) {
        updateImage(data: imageData)
    }
}

//MARK: - Set Constraints

extension WeatherView {
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            weatherIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cityNameLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -10),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            weatherDiscriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 0),
            weatherDiscriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherDiscriptionLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -10),
            weatherDiscriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
