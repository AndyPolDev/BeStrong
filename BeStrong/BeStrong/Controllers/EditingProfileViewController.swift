import UIKit
import RealmSwift

class EditingProfileViewController: UIViewController {
    
    private let editingProfileLabel = UILabel(text: "EDITING PROFILE", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        //
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(rgb: 0xC2C2C2)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(named: "addUser")
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addUserPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .white
        //
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addUserPhotoButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userPhotoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel = UILabel(text: "First Name")
    private let firstNameTextField = UITextField.createSimpleTextField()
    
    private let secondNameLabel = UILabel(text: "Second Name")
    private let secondNameTextField = UITextField.createSimpleTextField()
    
    private let heightLabel = UILabel(text: "Height")
    private let heightTextField = UITextField.createSimpleTextField()
    
    private let weightLabel = UILabel(text: "Weight")
    private let weightTextField = UITextField.createSimpleTextField()
    
    private let targetLabel = UILabel(text: "Target")
    private let targetTextField = UITextField.createSimpleTextField()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("SAVE", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoMedium16()
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let localRealm = try! Realm()
    private var userArray: Results<UserModel>!
    private var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        addRecognizers()
        setConstraints()
        
        userArray = localRealm.objects(UserModel.self)
        
        loadUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        addUserPhotoButton.layer.cornerRadius = userPhoto.frame.width / 2
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(editingProfileLabel)
        view.addSubview(closeButton)
        view.addSubview(userPhotoBackgroundView)
        view.addSubview(userPhoto)
        view.addSubview(addUserPhotoButton)
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(secondNameLabel)
        view.addSubview(secondNameTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(targetLabel)
        view.addSubview(targetTextField)
        view.addSubview(saveButton)
    }
    
    private func setDelegates() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
    }
    
    private func addRecognizers() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    private func setUserModel() {
        guard let firstName = firstNameTextField.text,
              let secondName = secondNameTextField.text,
              let userHeight = heightTextField.text,
              let userWeight = weightTextField.text,
              let userTarget = targetTextField.text else { return }
        
        guard let intUserHeight = Int(userHeight),
              let intUserWeight = Int(userWeight),
              let intUserTarget = Int(userTarget) else { return }
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeight = intUserHeight
        userModel.userWeight = intUserWeight
        userModel.userTarget = intUserTarget
        
        if userPhoto.image == UIImage(named: "addUser") {
            userModel.userImage = nil
        } else {
            guard let imageData = userPhoto.image?.pngData() else { return }
            userModel.userImage = imageData
        }
    }
    
    private func loadUserInfo() {
        if userArray.count != 0, userArray[0].userFirstName != "Unknown" {
            firstNameTextField.text = userArray[0].userFirstName
            secondNameTextField.text = userArray[0].userSecondName
            heightTextField.text = String(userArray[0].userHeight)
            weightTextField.text = String(userArray[0].userWeight)
            targetTextField.text = String(userArray[0].userTarget)
            
            guard let imageData = userArray[0].userImage else { return }
            guard let userImage = UIImage(data: imageData) else { return }
            userPhoto.image = userImage
            userPhoto.contentMode = .scaleAspectFit
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func addUserPhotoButtonPressed() {
        alertGalleryOrCamera { [weak self] source in
            guard let self else { return }
            self.chooseImagePicker(source: source)
        }
    }
    
    @objc private func saveButtonPressed() {
        setUserModel()
        
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(model: userModel)
        } else {
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
        dismiss(animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditingProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhoto.image = image
        userPhoto.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}


//MARK: - UITextFieldDelegate

extension EditingProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

//MARK: - Set Constraints

extension EditingProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            editingProfileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editingProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editingProfileLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: editingProfileLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
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
            userPhotoBackgroundView.heightAnchor.constraint(equalToConstant: 68)
        ])
        
        NSLayoutConstraint.activate([
            addUserPhotoButton.centerXAnchor.constraint(equalTo: userPhoto.centerXAnchor),
            addUserPhotoButton.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor),
            addUserPhotoButton.widthAnchor.constraint(equalTo: userPhoto.widthAnchor),
            addUserPhotoButton.heightAnchor.constraint(equalTo: userPhoto.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 40),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            firstNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 3),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            secondNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 15),
            secondNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            secondNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            secondNameTextField.topAnchor.constraint(equalTo: secondNameLabel.bottomAnchor, constant: 3),
            secondNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 15),
            heightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            heightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            heightTextField.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 3),
            heightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            heightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 15),
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            weightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 3),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 15),
            targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            targetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            targetTextField.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 3),
            targetTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            targetTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            targetTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: targetTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
