//
//  ObservableArray.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 18.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import Foundation

public class ObservableArray<T>: SequenceType {
    
    private(set) var value: [T]
    
    // MARK: Lifecycle
    
    init(_ initialValue: [T]) {
        value = initialValue
    }
    
    convenience init() {
        self.init([])
    }
    
    // MARK: Array methods
    
    public var count: Int {
        return value.count
    }
    
    public var capacity: Int {
        return value.capacity
    }
    
    public var isEmpty: Bool {
        return value.isEmpty
    }
    
    public var first: T? {
        return value.first
    }
    
    public var last: T? {
        return value.last
    }
    
    public func append(newElement: T) {
        dispatchWillInsert([value.count-1])
        value.append(newElement)
        dispatchDidInsert([value.count-1])
    }
    
    public func append(array: Array<T>) {
        splice(array, atIndex: value.count)
    }
    
    public func insert(newElement: T, atIndex i: Int) {
        dispatchWillInsert([i])
        value.insert(newElement, atIndex: i)
        dispatchDidInsert([i])
    }
    
    public func splice(array: Array<T>, atIndex i: Int) {
        if array.count > 0 {
            let indices = Array(i..<i+array.count)
            dispatchWillInsert(indices)
            value.splice(array, atIndex: i)
            dispatchDidInsert(indices)
        }
    }
    
    public func removeAtIndex(index: Int) -> T {
        dispatchWillRemove([index])
        let object = value.removeAtIndex(index)
        dispatchDidRemove([index])
        return object
    }
    
    public func removeLast() -> T {
        return removeAtIndex(count-1)
    }
    
    @available (iOS 9, *)
    public func removeAll(keepCapacity keepCapacity: Bool) {
        let count = value.count
        let indices = Array(0..<count)
        dispatchWillRemove(indices)
        value.removeAll(keepCapacity: keepCapacity)
        dispatchDidRemove(indices)
    }
    
    public func removeAll() {
        let count = value.count
        let indices = Array(0..<count)
        dispatchWillRemove(indices)
        value.removeAll()
        dispatchDidRemove(indices)
    }
    
    public func replaceAll(newArray: Array<T>) {
        let oldIndices = Array(0..<count)
        let newIndices = Array(0..<newArray.count)
        dispatchWillReplace(oldIndices)
        value.removeAll()
        value.splice(newArray, atIndex: 0)
        dispatchDidReplace(newIndices)
    }
    
    public subscript(index: Int) -> T {
        get {
            return value[index]
        }
        set(newObject) {
            if index == value.count {
                dispatchWillInsert([index])
                value[index] = newObject
                dispatchDidInsert([index])
            } else {
                dispatchWillUpdate([index])
                value[index] = newObject
                dispatchDidUpdate([index])
            }
        }
    }
    
    public func generate() -> ObservableArrayGenerator<T> {
        return ObservableArrayGenerator<T>(array: self)
    }
    
    // MARK: Bindings and Events
    let key = "value"
    let collectionChangedEvent = CollectionChangedEvent<T>()
    
    func dispatchWillInsert(changedIndizes: [Int]) {
        collectionChangedEvent.oldValue = value
    }
    
    func dispatchDidInsert(changedIndizes: [Int]) {
        collectionChangedEvent.trigger(key, newValue: value)
    }
    
    func dispatchWillRemove(changedIndizes: [Int]) {
        collectionChangedEvent.oldValue = value
    }
    
    func dispatchDidRemove(changedIndizes: [Int]) {
        collectionChangedEvent.trigger(key, newValue: value)
    }
    
    func dispatchWillUpdate(changedIndizes: [Int]) {
        collectionChangedEvent.oldValue = value
    }
    
    func dispatchDidUpdate(changedIndizes: [Int]) {
        collectionChangedEvent.trigger(key, newValue: value)
    }
    
    func dispatchWillReplace(changedIndizes: [Int]) {
        collectionChangedEvent.oldValue = value
    }
    
    func dispatchDidReplace(changedIndizes: [Int]) {
        collectionChangedEvent.trigger(key, newValue: value)
    }
}