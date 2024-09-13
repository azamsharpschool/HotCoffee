//
//  String+Extensions.swift
//  HotCoffee
//
//  Created by Mohammad Azam on 9/13/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
