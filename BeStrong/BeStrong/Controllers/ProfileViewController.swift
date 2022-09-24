import UIKit

class ProfileViewController: UIViewController {
    
    private let editingProfileLabel = UILabel(text: "PROFILE", font: .robotoMedium24(), textColor: .specialGray)
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(rgb: 0xC2C2C2)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
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
    
    private let userNameLabel = UILabel(text: "USER NAME", font: .robotoBold24(), textColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(editingProfileLabel)
        view.addSubview(userPhotoBackgroundView)
        view.addSubview(userPhoto)
        
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
    }
}
