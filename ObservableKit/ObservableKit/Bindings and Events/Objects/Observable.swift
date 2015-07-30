//
//  Observable.swift
//  Loyalty Cards
//
//  Created by Florian Rath on 30.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class Observable<T: Equatable> {
    
    private var _value: T
    public var value: T {
        get {
            return _value
        }
        set {
            if _value != newValue {
                valueChangedEvent.oldValue = _value
                _value = newValue
                valueChangedEvent.trigger(key, newValue: value)
            }
        }
    }
    public let valueChangedEvent: ValueChangedEvent<T>
    public let key = "value"
    
    public init(_ initialValue: T) {
        _value = initialValue
        valueChangedEvent = ValueChangedEvent<T>(initialValue)
    }
    
    public func setValue(newValue: T, forceEventTrigger: Bool) {
        if !forceEventTrigger {
            value = newValue
            return
        }
        
        valueChangedEvent.oldValue = _value
        _value = newValue
        valueChangedEvent.trigger(key, newValue: newValue)
    }
}