//
//  Models.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import Foundation

enum CoffeeSize: String, Codable, CaseIterable, Identifiable {
    
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var id: Self { return self }
}

struct Order: Codable, Identifiable, Hashable {
    var id: Int?
    let name: String
    let coffeeName: String
    let total: Double
    let size: CoffeeSize
}
