//
//  Pattern+mismatchs.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

extension Pattern where Value: Comparable {
    static func mismatchs(_ value: Value) -> Pattern {
        Pattern { $0 != value }
    }
}
