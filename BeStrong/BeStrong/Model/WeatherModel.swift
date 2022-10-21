import Foundation

struct WeatherModel: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Decodable {
    
    let description: String
    let icon: String
    
    var myDescription: String {
        switch description {
        case "clear sky": return "Clear sky"
        case "few clouds": return "Clouds"
        case "scattered clouds": return "Clouds"
        case "broken clouds": return "Clouds"
        case "overcast clouds": return "Clouds"
        case "shower rain": return "Shower rain"
        case "rain": return "Rain"
        case "thunderstorm": return "Thunderstorm"
        case "snow": return "Snow"
        case "mist": return "Mist"
        default: return "No data"
        }
    }
}

