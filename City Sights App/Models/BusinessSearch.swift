//
//  BusinessSearch.swift
//  City Sights App
//
//  Created by Jawid on 05/07/2021.
//

import Foundation

struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
}

struct Region: Decodable {
    var center = Coordinate()
}
