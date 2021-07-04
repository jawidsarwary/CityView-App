//
//  CitySightsApp.swift
//  City Sights App
//
//  Created by Jawid on 26/06/2021.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
 
