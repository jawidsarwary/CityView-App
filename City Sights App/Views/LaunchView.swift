//
//  LaunchView.swift
//  City Sights App
//
//  Created by Jawid on 26/06/2021.
//

import SwiftUI
import CoreLocation

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        // Detect the authorization status of geolocating the user
        if model.authorizationState == .notDetermined{
            // If undetermind, show onboarding
        }
        
        else if model.authorizationState == .authorizedAlways || model.authorizationState == .authorizedWhenInUse{
           //if approved, Show home view
            HomeView()
        }
        else{
        //if denied, show denied view
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
