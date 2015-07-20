//
//  BindableTextFieldTests.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 17.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import XCTest

class BindableTextFieldTests: XCTestCase {
    
    var tf = BindableTextField()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSynchronicity1() {
        tf.text = "Some random txt"
        XCTAssert(tf.text == tf.bindableText.value, "Text should be synchronized between .text and .bindableText.value")
    }
    
    func testSynchronicity2() {
        tf.text = "Some random txt"
        tf.bindableText <- "Other rand text"
        XCTAssert(tf.text == tf.bindableText.value, "Text should be synchronized between .text and .bindableText.value")
    }
    
    func testListenerCalledAfterSettingText() {
        let text = "a new text is born"
        
        let exp = self.expectationWithDescription("listener should be called")
        
        tf.bindableText.valueChangedEvent.addListener(self) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            XCTAssert(newValue == text, "new value should equal set text")
            exp.fulfill()
        }
        tf.text = text
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testListenerCalledAfterSettingBindableText() {
        let text = "another text is born"
        
        let exp = self.expectationWithDescription("listener should be called")
        
        tf.bindableText.valueChangedEvent.addListener(self) { (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            XCTAssert(newValue == text, "new value should equal set text")
            exp.fulfill()
        }
        tf.bindableText.value = text
        
        self.waitForExpectationsWithTimeout(1) { (error) -> Void in
            print("got error: \(error)")
        }
    }
    
    func testListenerGotRightValueAfterSimulatingKeystrokes() {
        tf.bindableText.valueChangedEvent.addListener(self) { [unowned self] (oldValue, newValue) -> Void in
            print("got new value: \(newValue)")
            XCTAssert("this should fit".hasPrefix(newValue!), "new value should equal set text")
            XCTAssert("this should fit".hasPrefix(self.tf.text!), "new value should equal set text")
            XCTAssert("this should fit".hasPrefix(self.tf.bindableText.value!), "new value should equal set text")
        }
        tf.text = "t"
        tf.text = tf.text! + "h"
        tf.text = tf.text! + "i"
        tf.text = tf.text! + "s"
        tf.text = tf.text! + " "
        tf.text = tf.text! + "s"
        tf.text = tf.text! + "h"
        tf.text = tf.text! + "o"
        tf.text = tf.text! + "u"
        tf.text = tf.text! + "l"
        tf.text = tf.text! + "d"
        tf.text = tf.text! + " "
        tf.text = tf.text! + "f"
        tf.text = tf.text! + "i"
        tf.text = tf.text! + "t"
    }
}
