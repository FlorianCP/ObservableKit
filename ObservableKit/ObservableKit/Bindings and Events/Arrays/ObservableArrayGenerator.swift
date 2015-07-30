//
//  ObservableArrayGenerator.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 20.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class ObservableArrayGenerator<T>: GeneratorType {
    
    private var index = -1
    private let array: ObservableArray<T>
    
    public init(array: ObservableArray<T>) {
        self.array = array
    }
    
    public typealias Element = T
    
    public func next() -> T? {
        index++
        return index < array.count ? array[index] : nil
    }
}