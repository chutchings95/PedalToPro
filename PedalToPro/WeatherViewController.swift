import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    var coord: CLLocationCoordinate2D!
    var weather: Weather!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var WindSpeedLabel: UILabel!
    @IBOutlet weak var WindDirectionLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        

    }
    
    func getWeather() {
        let parameters = [
            "lat": "\(coord.latitude)",
            "lon": "\(coord.longitude)",
            "units": "metric",
            "appid": "bc620920461d6ff26e97805183bf8fdd"]
        
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather", parameters: parameters)
            .response { request, response, data, error in
                
                if let data = data {
                    let weatherJSON = JSON(data: data)
                    self.weather = Weather(json: weatherJSON)
                    self.updateView()
                } else {
                    self.errorUpdate()
                }
                
                
        }
    }
    
    func updateView() {
        tempLabel.text = "\(weather.temp)°C \(weather.name)"
        LocationLabel.text = "\(weather.location.coordinate.latitude) / \(weather.location.coordinate.longitude)"
        WindSpeedLabel.text = "\(weather.windSpeed)kph"
        WindDirectionLabel.text = "\(weather.windDirection)°"
        DescriptionLabel.text = "\(weather.description)"
        weatherImage.image = UIImage(named: weather.title)
        print(weather.title)
    }
    
    func errorUpdate() {
        
    }
    
}





