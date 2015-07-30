//
//  Listener.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 16.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class OptionalListener<T> {
    
    public typealias ValueChangedBlock = (oldValue: T?, newValue: T?) -> Void
    
    public var key: String? = nil
    public weak var observer: AnyObject?
    public let action: ValueChangedBlock
    private let hash: String
    
    public init(key: String?, listener: AnyObject, action: ValueChangedBlock) {
        self.key = key
        self.observer = listener
        self.action = action
        self.hash = NSUUID().UUIDString
    }
    
    convenience public init(_ listener: AnyObject, action: ValueChangedBlock) {
        self.init(key: nil, listener: listener, action: action)
    }
    
    public func isEqual(otherListener: OptionalListener<T>) -> Bool {
        return self.hash == otherListener.hash
    }
}