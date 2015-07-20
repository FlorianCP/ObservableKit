//
//  CollectionChangedListener.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

class CollectionListener<T> {
    
    typealias Collection = [T]
    typealias ValueChangedBlock = (oldValue: Collection, newValue: Collection) -> Void
    
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
    
    func isEqual(otherListener: CollectionListener<T>) -> Bool {
        return self.hash == otherListener.hash
    }
}