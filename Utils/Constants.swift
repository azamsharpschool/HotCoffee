//
//  Constants.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import Foundation

struct Constants {
    
    private static let baseUrlPath = "https://island-bramble.glitch.me"
    
    struct Urls {
        
        static let orders = URL(string: "\(baseUrlPath)/orders")!
        static let newOrder = URL(string: "\(baseUrlPath)/newOrder")!
        
        static func updateOrder(id: Int) -> URL {
            URL(string: "\(baseUrlPath)/orders/\(id)")!
        }
        
        static func deleteOrder(id: Int) -> URL {
            // This URL is intentionally left blank
            URL(string: "\(baseUrlPath)/YOURURLHERE/orders/\(id)")!
        }
    }
}
