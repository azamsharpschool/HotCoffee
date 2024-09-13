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
    
    private var isFormValid: Bool {
       
        guard let totalValue = total, !name.isEmptyOrWhiteSpace, !coffeeName.isEmptyOrWhiteSpace, totalValue > 0 else {
            return false
        }
        
        return true
    }
    
    private func save() async {
        
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
        .navigationTitle("New Order")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await save()
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
