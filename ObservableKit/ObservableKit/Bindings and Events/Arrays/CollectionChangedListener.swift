//
//  CollectionChangedListener.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class CollectionListener<T> {
    
    public typealias Collection = [T]
    public typealias ValueChangedBlock = (oldValue: Collection, newValue: Collection) -> Void
    
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
    
    public func isEqual(otherListener: CollectionListener<T>) -> Bool {
        return self.hash == otherListener.hash
    }
}