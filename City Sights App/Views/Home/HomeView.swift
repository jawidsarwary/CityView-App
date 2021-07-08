//
//  HomeView.swift
//  City Sights App
//
//  Created by Jawid on 06/07/2021.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    
    var body: some View {
      
        if model.restuarants.count != 0 || model.sights.count != 0 {
            
            //Determine if we should show list or map
            
            if !isMapShowing {
                
                //show List
                
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        Image(systemName:"location")
                        Text("San Francisco")
                        Spacer()
                        Text("Switch to Map View")
                    }
                    Divider()
                    BusinessList()
                }
                
            }
            
            else{
                
                // Show Map
                
            }
            
        }
        
        else{
            
            //Stil waiting for data so show Spinning
            ProgressView()
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
