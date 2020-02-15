//
//  WeakObjectWrapper.swift
//  
//
//  Created by Christian Elies on 15.02.20.
//

final class WeakObjectWrapper<T: NSObject> {
    weak var value: T?
}
