//
//  ObservableOperators.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

infix operator <- { associativity right precedence 90 }

public func <-<T>(left: Observable<T>, right: T?) {
    left.value = right
}

public func +=<T>(left: Observable<T>, right: Listener<T>) {
    left.valueChangedEvent.addListener(right)
}