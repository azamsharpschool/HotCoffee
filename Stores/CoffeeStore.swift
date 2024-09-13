//
//  CoffeeStore.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import Foundation
import Observation

@Observable
class CoffeeStore {
    
    let httpClient: HTTPClient
    private(set) var orders: [Order] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadOrders() async throws {
        let resource = Resource(url: Constants.Urls.orders, modelType: [Order].self)
        orders = try await httpClient.load(resource)
    }
    
    func createOrder(_ order: Order) async throws {
        
        let orderData = try JSONEncoder().encode(order)
        let resource = Resource(url: Constants.Urls.newOrder, method: .post(orderData), modelType: Order.self)
        let order = try await httpClient.load(resource)
        orders.append(order)
    }
}

