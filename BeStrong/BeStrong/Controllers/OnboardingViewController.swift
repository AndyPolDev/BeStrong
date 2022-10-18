import UIKit

class OnboardingViewController: UIViewController {
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = .robotoBold20()
        button.tintColor = .specialGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.numberOfPages = 3
        pageControll.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        pageControll.isEnabled = false
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        return pageControll
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let idOnboardingCell = "idOnboardingCell"
    
    private var onboardingArray = [OnboardingStruct]()
    
    private var collectionItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialGreen
        
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        view.addSubview(collectionView)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: idOnboardingCell)
        
        guard let firstImage = UIImage(named: "onboardingFirst"),
              let secondImage = UIImage(named: "onboardingSecond"),
              let thirdImage = UIImage(named: "onboardingThird") else { return }
        
        let firstScreen = OnboardingStruct(topLabel: "Have a good health",
                                           bottomLabel: "Being healthy is all, no health is nothing. Why not?",
                                           image: firstImage)
        
        let secondScreen = OnboardingStruct(topLabel: "Be stronger",
                                            bottomLabel: "Take 30 minutes of bodybuilding every day to get physically fit and healthy.",
                                            image: secondImage)
        
        let thirdScreen = OnboardingStruct(topLabel: "Have a nice body",
                                           bottomLabel: "Bad body shape, poor sleep, lack of strength, weight gain, weak bones, easily traumatized body, depressed, stressed, poor metabolism, poor resistance",
                                           image: thirdImage)
        
        onboardingArray = [firstScreen, secondScreen, thirdScreen]
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "OnboardingViewed")
        
    }
    
    @objc private func nextButtonPressed() {
        if collectionItem == 1 {
            nextButton.setTitle("START", for: .normal)
        }
        
        if collectionItem == 2 {
            saveUserDefaults()
            dismiss(animated: true)
        } else {
            collectionItem += 1
            let index: IndexPath = [0, collectionItem]
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = collectionItem
        }
    }
}

//MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idOnboardingCell, for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = onboardingArray[indexPath.row]
        cell.cellConfigure(model: model)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - Set Constraints

extension OnboardingViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20)
        ])
    }
}
