import Foundation
import CoreLocation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let apiKey = "87f30e7da8448fba5a1a480d33c569a9"
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?units=metric&lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
