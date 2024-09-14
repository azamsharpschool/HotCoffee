//
//  AddCoffeeOrderScreen.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/13/24.
//

import SwiftUI

struct AddCoffeeOrderScreen: View {
    
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var total: Double?
    @State private var coffeeSize: CoffeeSize = .medium
    
    @Environment(CoffeeStore.self) private var coffeeStore
    @Environment(\.dismiss) private var dismiss
    
    var order: Order? 
    
    private var isFormValid: Bool {
       
        guard let totalValue = total, !name.isEmptyOrWhiteSpace, !coffeeName.isEmptyOrWhiteSpace, totalValue > 0 else {
            return false
        }
        
        return true
    }
    
    private func saveCoffeeOrder() async {
        
        guard let total = total else {
            return
        }
        
        let order = Order(name: name, coffeeName: coffeeName, total: total, size: coffeeSize)
        
        do {
            try await coffeeStore.createOrder(order)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func updateCoffeeOrder() async {
        
        guard let order = order,
              let orderId = order.id,
              let total = total else { return }
        
        let orderToUpdate = Order(id: orderId, name: name, coffeeName: coffeeName, total: total, size: coffeeSize)
        
        do {
            try await coffeeStore.updateOrder(orderToUpdate)
            dismiss() 
        } catch {
            print(error)
        }
        
    }
    
    private var navigationTitle: String {
        order != nil ? "Update Order": "New Order"
    }
    
    private var saveOrUpdateButtonTitle: String {
        order != nil ? "Update": "Save"
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Coffee name", text: $coffeeName)
            TextField("Total", value: $total, format: .number)
            Picker("Select Size", selection: $coffeeSize) {
                ForEach(CoffeeSize.allCases) { size in
                    Text(size.rawValue)
                }
            }.pickerStyle(.segmented)
        }
        .onAppear(perform: {
            if let order {
                name = order.name
                coffeeName = order.coffeeName
                total = order.total
                coffeeSize = order.size
            }
        })
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(saveOrUpdateButtonTitle) {
                    Task {
                        if order != nil {
                            await updateCoffeeOrder()
                        } else {
                            await saveCoffeeOrder()
                        }
                    }
                }.disabled(!isFormValid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddCoffeeOrderScreen()
    }.environment(CoffeeStore(httpClient: HTTPClient()))
}
