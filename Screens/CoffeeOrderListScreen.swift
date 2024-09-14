//
//  CoffeeOrderListScreen.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/12/24.
//

import SwiftUI

struct CoffeeOrderListScreen: View {
    
    @Environment(CoffeeStore.self) private var coffeeStore
    @State private var sheet: Sheet?
    @State private var selectedOrder: Order?
    
    private enum Sheet: Identifiable, View {
        
        case newOrder
        case updateOrder(Order)
        
        var id: String {
            switch self {
            case .newOrder:
                return "newOrder"
            case .updateOrder(let order):
                return "updateOrder_\(String(describing: order.id))"
            }
        }
        
        var body: some View {
            NavigationStack {
                switch self {
                    case .newOrder:
                        AddCoffeeOrderScreen()
                    case .updateOrder(let order):
                        AddCoffeeOrderScreen(order: order)
                }
            }
        }
        
    }
    
    var body: some View {
        List(coffeeStore.orders) { order in
            NavigationLink(value: order) {
                Text(order.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedOrder = order
                    }
                    .onLongPressGesture {
                        sheet = .updateOrder(order)   
                    }
            }
        }
        .navigationDestination(item: $selectedOrder, destination: { order in
            Text(order.name)
        })
        .navigationTitle("All Orders")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Order") {
                    sheet = .newOrder
                }
            }
        })
        .sheet(item: $sheet, content: { sheet in
            sheet
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
