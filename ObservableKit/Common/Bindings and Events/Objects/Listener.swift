//
//  Listener.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 16.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

class Listener<T> {
    typealias ValueChangedBlock = (oldValue: T?, newValue: T?) -> Void
    
    var key: String? = nil
    weak var observer: AnyObject?
    let action: ValueChangedBlock
    private let hash: String
    
    init(key: String?, listener: AnyObject, action: ValueChangedBlock) {
        self.key = key
        self.observer = listener
        self.action = action
        self.hash = NSUUID().UUIDString
    }
    
    convenience init(_ listener: AnyObject, action: ValueChangedBlock) {
        self.init(key: nil, listener: listener, action: action)
    }
    
    func isEqual(otherListener: Listener<T>) -> Bool {
        return self.hash == otherListener.hash
    }
}