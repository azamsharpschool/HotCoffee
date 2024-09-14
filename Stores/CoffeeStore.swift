//
//  CoffeeStore.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import Foundation
import Observation

enum OrderError: LocalizedError {
    case invalidOrder(String)
    
    var errorDescription: String? {
        switch self {
            case .invalidOrder(let message):
                return "Order Error: \(message)"
        }
    }
}

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
    
    func updateOrder(_ order: Order) async throws {
        
        guard let orderId = order.id else {
            throw OrderError.invalidOrder("Order Id is missing or invalid")
        }
        
        let orderData = try JSONEncoder().encode(order)
        let resource = Resource(url: Constants.Urls.updateOrder(id: orderId), method: .put(orderData), modelType: Order.self)
        let updatedOrder = try await httpClient.load(resource)
        
        guard let updatedOrderId = updatedOrder.id else {
            throw OrderError.invalidOrder("Update failed. Update order is missing an ID.")
        }
        
        guard let index = orders.firstIndex(where: { $0.id == updatedOrderId }) else {
            throw OrderError.invalidOrder("Order with ID \(updatedOrderId) not found.")
        }
        
        orders[index] = updatedOrder
    }
}

