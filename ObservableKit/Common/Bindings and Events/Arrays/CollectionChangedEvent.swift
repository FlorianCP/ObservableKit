//
//  CollectionChangedEvent.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 18.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class CollectionChangedEvent<T> {
    
    public typealias Collection = [T]
    public typealias ValueChangedBlock = (oldValue: Collection, newValue: Collection) -> Void
    
    public var listeners = [CollectionListener<T>]()
    
    public init() {}
    
    public func addListener(key: String, listener: AnyObject, eventBlock: ValueChangedBlock) {
        // Bail out if we already have added the listener
        guard hasListener(listener) == false else {
            return
        }
        
        listeners.append(CollectionListener<T>(key: key, listener: listener, action: eventBlock))
    }
    
    public func addListener(listener: AnyObject, eventBlock: ValueChangedBlock) {
        // Bail out if we already have added the listener
        guard hasListener(listener) == false else {
            return
        }
        
        listeners.append(CollectionListener(listener, action: eventBlock))
    }
    
    public func addListener(listener: CollectionListener<T>) {
        // Bail out if we already have added the listener
        guard hasListener(listener) == false else { return }
        
        listeners.append(listener)
    }
    
    public func removeListener(listener: AnyObject) {
        clearStaleListeners()
        
        let foundListeners = listeners.filter { $0.observer!.isEqual(listener) }
        guard foundListeners.count > 0 else {
            return
        }
        let index = listeners.indexOf { $0.observer!.isEqual(listener) }
        guard let i = index else {
            return
        }
        listeners.removeAtIndex(i)
    }
    
    public func hasListener(listener: AnyObject) -> Bool {
        clearStaleListeners()
        
        let foundListeners = listeners.filter { $0.observer!.isEqual(listener) }
        if foundListeners.count > 0 {
            return true
        }
        return false
    }
    
    public func clearStaleListeners() {
        for l in listeners {
            if l.observer == nil {
                let index = listeners.indexOf { $0.isEqual(l) }
                if let i = index {
                    listeners.removeAtIndex(i)
                }
            }
        }
    }
    
    public var oldValue = Collection()
    
    public func trigger(key: String, newValue: Collection) {
        clearStaleListeners()
        
        let interestedListeners = listeners.filter { $0.key == nil || $0.key == key }
        for l in interestedListeners {
            l.action(oldValue: oldValue, newValue: newValue)
        }
    }
}