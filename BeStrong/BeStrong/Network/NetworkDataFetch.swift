import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchWeather(responce: @escaping (WeatherModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData { result in
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
