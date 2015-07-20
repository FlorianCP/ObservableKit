//
//  ValueChangedOperators.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

func +=<T>(left: ValueChangedEvent<T>, right: Listener<T>) {
    left.addListener(right)
}