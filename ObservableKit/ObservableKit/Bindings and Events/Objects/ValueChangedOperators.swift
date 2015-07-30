//
//  ValueChangedOperators.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public func +=<T>(left: ValueChangedEvent<T>, right: Listener<T>) {
    left.addListener(right)
}

public func +=<T>(left: OptionalValueChangedEvent<T>, right: OptionalListener<T>) {
    left.addListener(right)
}