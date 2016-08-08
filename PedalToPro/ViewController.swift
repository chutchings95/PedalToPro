import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var completed = 0
    var weatherCoord: CLLocationCoordinate2D?
    var showingAlert = false
    @IBOutlet weak var weatherButton: UIBarButtonItem!
    
    
    var alertController:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherButton.enabled = false
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.delegate = self
        
        let bournemouthPier = CLLocationCoordinate2D(latitude: 50.716098, longitude: -1.875780)
        let bournemouthPierRegion = CLCircularRegion(center: bournemouthPier, radius: 30, identifier: "Start Point")
        locationManager.startMonitoringForRegion(bournemouthPierRegion)
        
        let boscombePier = CLLocationCoordinate2D(latitude: 50.735218, longitude: -1.778761)
        let boscombePierRegion = CLCircularRegion(center: boscombePier, radius: 30, identifier: "Second Point")
        locationManager.startMonitoringForRegion(boscombePierRegion)

        let christchurch = CLLocationCoordinate2D(latitude: 50.816482, longitude: -1.571763)
        let christchurchRegion = CLCircularRegion(center: christchurch, radius: 30, identifier: "Third Point")
        locationManager.startMonitoringForRegion(christchurchRegion)
        
        let brock = CLLocationCoordinate2D(latitude: 50.815412, longitude: -1.575826)
        let brockRegion = CLCircularRegion(center: brock, radius: 30, identifier: "Fourth Point")
        locationManager.startMonitoringForRegion(brockRegion)

        let ringwood = CLLocationCoordinate2D(latitude: 50.842360, longitude: -1.785079)
        let ringwoodRegion = CLCircularRegion(center: ringwood, radius: 30, identifier: "Fifth Point")
        locationManager.startMonitoringForRegion(ringwoodRegion)
    
        let ferndown = CLLocationCoordinate2D(latitude: 50.805935, longitude: -1.898478)
        let ferndownRegion = CLCircularRegion(center: ferndown, radius: 30, identifier: "Sixth Point")
        locationManager.startMonitoringForRegion(ferndownRegion)
        
        let gardens = CLLocationCoordinate2D(latitude: 50.716098, longitude: 1.875780)
        let gardensRegion = CLCircularRegion(center: gardens , radius: 30, identifier: "End Point")
        locationManager.startMonitoringForRegion(gardensRegion)
        
    }
    
    
    func clearMap() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    func addRouteToMap(route: MKRoute) {
        clearMap()
        mapView.addOverlay(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0), animated: true)
        mapView.setUserTrackingMode(.None, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "ShowWeather"{
            let vc = segue.destinationViewController as! WeatherViewController
            vc.coord = weatherCoord
        }
        
    }

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.lineWidth = 5
        polylineRenderer.strokeColor = UIColor(r: 93, g: 93, b: 93, a: 0.6)
        return polylineRenderer
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // We know our region is a circular one, so we're casting it as one
        let circleRegion = region as! CLCircularRegion
        
        if completed < 5 {
            completed++

            weatherButton.enabled = true
            let directionsRequest = MKDirectionsRequest()
            directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: circleRegion.center, addressDictionary: nil))
            directionsRequest.requestsAlternateRoutes = true
            directionsRequest.transportType = .Walking
            
            
            if region.identifier == "Start Point" {
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.735218, longitude: -1.778761), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.735218, longitude: -1.778761)

                
            }
            
            
            if region.identifier == "Second Point" {
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.816482, longitude: -1.571763), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.816482, longitude: -1.571763)
            }

            if region.identifier == "Third Point" {
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.735218, longitude: -1.778761), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.735218, longitude: -1.778761)
            }
            
            if region.identifier == "Fourth Point" {
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.838725, longitude: -1.782708), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.838725, longitude: -1.782708)
            }
            
            if region.identifier == "Fifth Point" {
                print("ringwoodRegion")
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.805935, longitude: -1.898478), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.805935, longitude: -1.898478)
            }
            
            if region.identifier == "Sixth Point" {
                directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 50.716098, longitude: -1.875780), addressDictionary: nil))
                weatherCoord = CLLocationCoordinate2D(latitude: 50.716098, longitude: -1.875780)
                
            }
            let directions = MKDirections(request: directionsRequest)
            directions.calculateDirectionsWithCompletionHandler( {(response: MKDirectionsResponse?, error: NSError?) in
                if let routeResponse = response?.routes {
                    let quickestRouteForSegment: MKRoute = routeResponse.sort({$0.expectedTravelTime < $1.expectedTravelTime})[0]
                    self.addRouteToMap(quickestRouteForSegment)
                    self.timeLabel.text = "Time to next region: \(Double((quickestRouteForSegment.expectedTravelTime/3) / 60 ).roundToPlaces(1)) minutes"
                    self.distanceLabel.text = "Distance to next region: \(Double(quickestRouteForSegment.distance/1000).roundToPlaces(2))km"
                }
            })
        } else {
            
            if region.identifier == "Start Point" {
                let overlays = mapView.overlays
                mapView.removeOverlays(overlays)
                
                if !showingAlert {
                    showingAlert = true
                    let refreshAlert = UIAlertController(title: "Well Done!", message: "You have cycled...", preferredStyle: UIAlertControllerStyle.Alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.showingAlert = false
                    }))
                    presentViewController(refreshAlert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
}





