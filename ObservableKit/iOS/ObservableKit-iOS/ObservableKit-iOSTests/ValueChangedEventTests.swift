//
//  ValueChangedEventTests.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 16.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import XCTest

class ValueChangedEventTests: XCTestCase {
    
    var testerA = ChangeTester()
    var testerB: ChangeTester? = ChangeTester()
    var testerC = ChangeTester()
    var testerD = ChangeTester()
    var testerObs = ObservableTester()
    var testerObsInt = ObsIntTester()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testChangedEventRaised() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerA.testVar = "blah"
        testerA.event.addListener("testVar", listener: testerB!) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerA.testVar = "muh"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testNilOldValue() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerA.event.addListener("testVar", listener: testerB!) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            if oldValue == nil {
                exp.fulfill()
            }
        }
        testerA.testVar = "muh"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testMultipleListeners() {
        let e1 = self.expectationWithDescription("value changed block should be called")
        let e2 = self.expectationWithDescription("value changed block should be called")
        let e3 = self.expectationWithDescription("value changed block should be called")
        
        testerA.event.addListener("testVar", listener: testerB!) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            e1.fulfill()
        }
        testerA.event.addListener("testVar", listener: testerC) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            e2.fulfill()
        }
        testerA.event.addListener("testVar", listener: testerD) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            e3.fulfill()
        }
        testerA.testVar = "muh"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testObservable() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObs.property.valueChangedEvent.addListener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObs.property.value = "new value for observable property"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testStringAssignmentOperators() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObs.property.valueChangedEvent.addListener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObs.property <- "new value for observable property"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testIntAssignmentOperators() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObsInt.property.valueChangedEvent.addListener(testerA) { (oldValue, newValue) -> Void in
            print("got old value: \(oldValue), new value: \(newValue)")
            exp.fulfill()
        }
        testerObsInt.property <- 4
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testStringEventListenerConvenienceOperator() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObs.property += Listener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObs.property.value = "new value for observable property"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testIntEventListenerConvenienceOperator() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObsInt.property += Listener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObsInt.property.value = 42
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testStringEventListenerOperator() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObs.property.valueChangedEvent += Listener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObs.property.value = "new value for observable property"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testIntEventListenerOperator() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerObsInt.property.valueChangedEvent += Listener(testerA) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerObsInt.property.value = 42
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    // This test is disabled, since it is intended to fail.
    // However, the bad tester I am, I have no idea how I can express this with XCTest.
    func DISABLED_testNoListenerCallbackDueToWrongKey() {
        let exp = self.expectationWithDescription("value changed block should be called")
        
        testerA.testVar = "blah"
        testerA.event.addListener("unknownKey", listener: testerB!) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerA.testVar = "muh"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    // This test is disabled, since it is intended to fail.
    // However, the bad tester I am, I have no idea how I can express this with XCTest.
    func DISABLED_testListenerDeinited() {
        let exp = self.expectationWithDescription("value changed block should never be called")
        
        testerA.testVar = "blah"
        testerA.event.addListener("testVar", listener: testerB!) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            exp.fulfill()
        }
        testerB = nil
        testerA.testVar = "muh"
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            XCTAssert(error != nil, "expectations should not be called")
            print("got error: \(error)")
        }
    }
}


class ChangeTester {
    var testVar: String? {
        willSet { event.oldValue = testVar }
        didSet { event.trigger("testVar", newValue: testVar!) }
    }
    let event = ValueChangedEvent<String>()
}

class ObservableTester {
    var property = Observable<String>()
}

class ObsIntTester {
    var property = Observable<Int>()
}