import Foundation
import CoreLocation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, responce: @escaping (WeatherModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(lat: lat, lon: lon) { result in
            switch result {
            case .success(let data):
                do {
                    let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                    responce(weatherData, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError.localizedDescription)
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}
