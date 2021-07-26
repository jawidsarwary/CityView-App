//
//  BusinessMap.swift
//  City Sights App
//
//  Created by Jawid on 25/07/2021.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    
    var locations: [MKPointAnnotation]{
        
        var annotations = [MKPointAnnotation]()
        // Create a set of annotations from our list of business
        
        for business in model.restuarants + model.sights{
            // if the business has a lat/long, create a MKPointAnnotation for it.
            
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude{
                //create a new annotation
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name ?? ""
                
                annotations.append(a)
            }
        }
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        //Make the user show up the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        // TODO: Set the Region
        
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //Remove all annotations
        //uiView.removeAnnotations(uiView.annotations)
        uiView.showAnnotations(self.locations, animated: true)
        
        
    }
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        
        uiView.removeAnnotations(uiView.annotations)
        
    }
}
