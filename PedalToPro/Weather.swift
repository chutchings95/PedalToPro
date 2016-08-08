import UIKit
import SwiftyJSON
import CoreLocation

class Weather {
    
    let windSpeed: Double!
    let windDirection: Double!
    let title: String!
    let location: CLLocation!
    let icon: String!
    let temp: Double!
    let description: String!
    let name: String!
    
    
    
    init(json: JSON) {
        
        windSpeed = json["wind"]["speed"].doubleValue
        windDirection = json["wind"]["deg"].doubleValue
        title = json["weather"][0]["main"].stringValue
        location = CLLocation(latitude: json["coord"]["lat"].doubleValue, longitude: json["coord"]["lon"].doubleValue)
        icon = json["weather"][0]["icon"].stringValue
        temp = json["main"]["temp"].doubleValue
        description = json["weather"][0]["description"].stringValue
        name = json["name"].stringValue
    
    }
    

}




