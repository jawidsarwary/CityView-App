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
    @Binding var selectedBusiness: Business?
    
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
        mapView.delegate = context.coordinator
        
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
    
    //MARK - Coordinator Class
    func makeCoordinator() -> Coordinator{
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var map: BusinessMap
        init(map: BusinessMap){
            self.map = map
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //if the annotation is the user blue dot, return nil
            if annotation is MKUserLocation {
                return nil
            }
            // Check if there's a reusable annotation view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
           
            if annotationView == nil {
                //create an annotatio view
                 annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else{
                
                //we got a reusable one
                annotationView!.annotation = annotation
            }
            
            //Return it
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //user tapped on the annotation view
            
            //Get the business object that this annotation represents
            
            //loop through business in the model and find a match
            for business in map.model.restuarants + map.model.sights {
                if business.name == view.annotation?.title{
                    //Set the selectedBusiness property to that business object
                    map.selectedBusiness = business
                    return
                }
            }
        }
        
    }
}
