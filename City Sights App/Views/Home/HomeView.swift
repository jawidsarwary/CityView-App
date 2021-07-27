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
    @State var selectedBusiness: Business?
    
    var body: some View {
      
        if model.restuarants.count != 0 || model.sights.count != 0 {
            
            //Determine if we should show list or map
            
            NavigationView{
                
                if !isMapShowing {
                    
                    //show List
                    
                    VStack(alignment: .leading){
                        
                        HStack{
                            
                            Image(systemName:"location")
                            Text("San Francisco")
                            Spacer()
                            Button("Switch to Map View"){
                                self.isMapShowing = true
                            }
                        }
                        Divider()
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                    
                }
                
                else{
                    
                    // Show Map
                    BusinessMap(selectedBusiness: $selectedBusiness)
                        .ignoresSafeArea()
                        .sheet(item: $selectedBusiness) { business in
                            // create a business detail view instance
                            // pass in teh selected business
                            BusinessDetail(business: business)
                        }
                }
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
