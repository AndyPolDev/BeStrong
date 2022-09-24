import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveWorkoutModel(model: WorkoutModel) {
        try! localRealm.write{
            localRealm.add(model)
        }
    }
    
    func deleteWorkoutModel(model: WorkoutModel) {
        try! localRealm.write{
            localRealm.delete(model)
        }
    }
    
    func updateSetsRepsWorkoutModel(model: WorkoutModel, sets: Int, reps: Int) {
        try! localRealm.write{
            model.workoutSets = sets
            model.workoutReps = reps
        }
    }
    
    func updateSetsTimerWorkoutModel(model: WorkoutModel, sets: Int, timer: Int) {
        try! localRealm.write{
            model.workoutSets = sets
            model.workoutTimer = timer
        }
    }
    
    func updateStatusWorkoutModel(model: WorkoutModel, bool: Bool = true) {
        try! localRealm.write{
            model.workoutStatus = bool
        }
    }
}