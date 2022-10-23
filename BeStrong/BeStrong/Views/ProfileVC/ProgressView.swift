import UIKit
import RealmSwift

class ProgressView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionVIew = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        collectionVIew.bounces = false
        collectionVIew.showsHorizontalScrollIndicator = true
        collectionVIew.backgroundColor = .none
        return collectionVIew
    }()
    
    private let idProgressCollectionViewCell = "idProgressCollectionViewCell"
    
    private var resultWorkout = [ResultWorkout]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegates()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        collectionView.register(ProgressCollectionViewCell.self,
                                forCellWithReuseIdentifier: idProgressCollectionViewCell)
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getWorkoutName(model: Results<WorkoutModel>!) -> [String] {
        
        var nameArray = [String]()
        
        for workoutModel in model {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getWorkoutResults(model:  Results<WorkoutModel>!) {
        
        let nameArray = getWorkoutName(model: model)
        
        for name in nameArray {
            let predicateName = NSPredicate(format: "workoutName = '\(name)'")
            
            let workoutModel = model
                .filter(predicateName)
                .sorted(byKeyPath: "workoutName")
            var result = 0
            var timer = 0
            var image: Data?
            workoutModel.forEach { model in
                result += model.workoutReps
                timer += model.workoutTimer
                image = model.workoutImage
            }
            
            let resultModel = ResultWorkout(name: name, result: result, time: timer, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
    
    internal func configureProgressCollectionView(model: Results<WorkoutModel>!) {
        resultWorkout = [ResultWorkout]()
        getWorkoutResults(model: model)
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource

extension ProgressView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idProgressCollectionViewCell, for: indexPath) as! ProgressCollectionViewCell
        let model = resultWorkout[indexPath.row]
        cell.cellConfigure(model: model)
        cell.backgroundColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3 ? .specialGreen : .specialDarkYellow)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProgressView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select \(indexPath.item)")
        //progressView.setProgress(0.6, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProgressView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2.07,
               height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

//MARK: - Set Constraints

extension ProgressView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
