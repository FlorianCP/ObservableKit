//
//  ObservableArrayTests.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 18.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import XCTest

class ObservableArrayTests: XCTestCase {
    
    var strings = ObservableArray<String>()
    var ints = ObservableArray<Int>()

    override func setUp() {
        super.setUp()
        
        strings = ObservableArray<String>(["Eins", "Zwei", "Drei", "Vier"])
        ints = ObservableArray<Int>([1, 2, 3, 4])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringAppend() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 5)
            XCTAssert(newValue.last! == "Fünf")
        })
        XCTAssert(strings.count == 4)
        strings.append("Fünf")
        XCTAssert(strings.count == 5)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testIntAppend() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 5)
            XCTAssert(newValue.last! == 5)
        })
        XCTAssert(ints.count == 4)
        ints.append(5)
        XCTAssert(ints.count == 5)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testStringAppendArray() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 7)
            XCTAssert(newValue.last! == "Sieben")
            })
        XCTAssert(strings.count == 4)
        strings.append(["Fünf", "Sechs", "Sieben"])
        XCTAssert(strings.count == 7)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testIntAppendArray() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 7)
            XCTAssert(newValue.last! == 7)
            })
        XCTAssert(ints.count == 4)
        ints.append([5, 6, 7])
        XCTAssert(ints.count == 7)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testInsertString() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 5)
            XCTAssert(newValue[3] == "Dreieinhalb")
            })
        XCTAssert(strings.count == 4)
        strings.insert("Dreieinhalb", atIndex: 3)
        XCTAssert(strings.count == 5)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testInsertInt() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 5)
            XCTAssert(newValue[3] == 99)
            })
        XCTAssert(ints.count == 4)
        ints.insert(99, atIndex: 3)
        XCTAssert(ints.count == 5)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testStringSplice() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 6)
            XCTAssert(newValue[1] == "Fünf")
            XCTAssert(newValue[2] == "Sechs")
            XCTAssert(newValue.last! == "Vier")
            })
        
        XCTAssert(strings.count == 4)
        strings.splice(["Fünf", "Sechs"], atIndex: 1)
        XCTAssert(strings.count == 6)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testIntSplice() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 6)
            XCTAssert(newValue[1] == 5)
            XCTAssert(newValue[2] == 6)
            XCTAssert(newValue.last! == 4)
            })
        
        XCTAssert(ints.count == 4)
        ints.splice([5, 6], atIndex: 1)
        XCTAssert(ints.count == 6)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveStringAtIndex() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 3)
            XCTAssert(newValue[1] == "Drei")
        })
        
        XCTAssert(strings.count == 4)
        let removed = strings.removeAtIndex(1)
        XCTAssert(strings.count == 3)
        XCTAssert(removed == "Zwei")
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveIntAtIndex() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 3)
            XCTAssert(newValue[1] == 3)
        })
        
        XCTAssert(ints.count == 4)
        let removed = ints.removeAtIndex(1)
        XCTAssert(ints.count == 3)
        XCTAssert(removed == 2)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveAllStrings() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 0)
            })
        
        XCTAssert(strings.count == 4)
        if #available(iOS 9, *) {
            let cap = strings.capacity
            strings.removeAll(keepCapacity: true)
            XCTAssert(strings.capacity == cap)
        } else {
            strings.removeAll()
            XCTAssert(strings.capacity == 0)
        }
        
        XCTAssert(strings.count == 0)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveAllInts() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 0)
            })
        
        XCTAssert(ints.count == 4)
        if #available(iOS 9, *) {
            let cap = ints.capacity
            ints.removeAll(keepCapacity: true)
            XCTAssert(ints.capacity == cap)
        } else {
            ints.removeAll()
            XCTAssert(ints.capacity == 0)
        }
        
        XCTAssert(ints.count == 0)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveAllStringsFlushingCapacity() {
        let exp = self.expectationWithDescription("listener should be called")
        strings.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 0)
            })
        
        XCTAssert(strings.count == 4)
        if #available(iOS 9, *) {
            strings.removeAll(keepCapacity: false)
        } else {
            strings.removeAll()
        }
        XCTAssert(strings.count == 0)
        XCTAssert(strings.capacity == 0)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.strings.collectionChangedEvent.removeListener(self)
        }
    }
    
    func testRemoveAllIntsFlushingCapacity() {
        let exp = self.expectationWithDescription("listener should be called")
        ints.collectionChangedEvent.addListener(CollectionListener(self) { (oldValue, newValue) -> Void in
            exp.fulfill()
            XCTAssert(newValue.count == 0)
            })
        
        XCTAssert(ints.count == 4)
        if #available(iOS 9, *) {
            ints.removeAll(keepCapacity: false)
        } else {
            ints.removeAll()
        }
        XCTAssert(ints.count == 0)
        XCTAssert(ints.capacity == 0)
        
        self.waitForExpectationsWithTimeout(1) { [unowned self] (error) -> Void in
            print("got error: \(error)")
            self.ints.collectionChangedEvent.removeListener(self)
        }
    }

}
