//
//  HotCoffeeApp.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import SwiftUI

@main
struct HotCoffeeApp: App {
    
    @State private var coffeeStore = CoffeeStore(httpClient: HTTPClient())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CoffeeOrderListScreen()
            }.environment(coffeeStore)
        }
    }
}
