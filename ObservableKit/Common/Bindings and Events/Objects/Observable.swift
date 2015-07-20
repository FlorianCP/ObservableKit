//
//  Observable.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 17.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

class Observable<T: Equatable> {
    
    private var _value: T?
    var value: T? {
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
    let valueChangedEvent = ValueChangedEvent<T>()
    let key = "value"
    
    init(_ initialValue: T?) {
        _value = initialValue
    }
    
    convenience init() {
        self.init(nil)
    }
    
    func setValue(newValue: T?, forceEventTrigger: Bool) {
        if !forceEventTrigger {
            value = newValue
            return
        }
        
        valueChangedEvent.oldValue = _value
        _value = newValue
        valueChangedEvent.trigger(key, newValue: newValue)
    }
}