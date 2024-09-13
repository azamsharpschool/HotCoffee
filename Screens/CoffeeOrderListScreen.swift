//
//  CoffeeOrderListScreen.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import SwiftUI

struct CoffeeOrderListScreen: View {
    
    @Environment(CoffeeStore.self) private var coffeeStore
    @State private var isPresented: Bool = false
    
    var body: some View {
        List(coffeeStore.orders) { order in
            Text(order.name)
        }
        .navigationTitle("All Orders")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Order") {
                    isPresented = true
                }
            }
        })
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddCoffeeOrderScreen()
            }
        })
        .task {
            do {
                try await coffeeStore.loadOrders()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeOrderListScreen()
    }.environment(CoffeeStore(httpClient: HTTPClient()))
}
