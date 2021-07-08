//
//  ContentModel.swift
//  City Sights App
//
//  Created by Jawid on 04/07/2021.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var restuarants = [Business]()
    @Published var sights = [Business]()
    
    override init (){
        
        // init method of NSObject
        
        super.init()
        
        // Set content model as the delegate of the location manager
        locationManager.delegate = self
        
        //Request permission from the user
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    //MARK: Location Manager Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // update the authorizationState property
        
        authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse{
            
            //We have permission
            //TODO: Start geolocating the user, after we get permission
            locationManager.startUpdatingLocation()
            
        }
        else if locationManager.authorizationStatus == .denied{
            
            //we don't have permission
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Gives us the location of the user
        
        let userLocation = locations.first
        
        if userLocation != nil {
            
            //we have a location
            //stop requesting the location
            
            locationManager.stopUpdatingLocation()
            
            //if we have the coordinate of the user, send into Yelp API
            
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            
            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
            
            
        }
        
        
    }
    
    func getBusinesses(category:String, location: CLLocation){
        
        //Create URL
        /*
         
         let urlStrin = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
         let url = URL(string: urlString)
         
         */
        
        
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
            
        ]
        
        let url = urlComponents?.url
        
        if let url = url{
            
            // Create URL Request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.addValue(Constants.apiKey, forHTTPHeaderField: "Authorization")
            
            //Get URLSession
            let session = URLSession.shared
            
            //Create Data Task
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                //Check that there is not an error
                
                if error == nil {
                    
                    do{
                        //parse json
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        DispatchQueue.main.async {
                            //Assign results to the appropriate property
                            
                            switch category{
                            
                            case Constants.sightsKey:
                                self.sights = result.businesses
                                
                            case Constants.restaurantsKey:
                                self.restuarants = result.businesses
                                
                            default:
                                break
                                
                            }
                        }
                        
                    }
                    catch{
                        print(error)
                    }
                    
                }
                
            }
            //Start the data Task
            dataTask.resume()
        }
    }
    
}
