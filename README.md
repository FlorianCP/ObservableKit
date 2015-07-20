# ObservableKit

ObservableKit is a framework written in Swift 2.0. It helps with reactive programming, as it provides simple mechanisms and objects to watch for object's value changes.

There are several other frameworks out there (like [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), [SwiftBond](https://github.com/SwiftBond/Bond) and [Observable-Swift](https://github.com/slazyk/Observable-Swift)) which heavily inspired ObservableKit.
However, at the current time of writing, I was not satisfied with either of them. ReactiveCocoa is great, but very heavyweight and presents a stiff entry-barrier. SwiftBond is also great, but at the time of writing only supported one Observer per observable object. Observable-Swift posed the same limitation.

ObservableKit aims to provide a lightweight way to have observable objects with multiple observers. It should be easy to integrate into existing projects and only make a small part of your app reactive.

## What is supported

Currently, ObservableKit supports Observable objects (such as Int, String, CLLocation and your own classes) in a generic way.
It also supports Observable Arrays, e.g. an Array of CLLocation objects.

## How to observe objects

Creating an observable object is easy. Values of observables are optionals, so they may be nil.
```swift
// type is automatically inferred
var canUndo = Observable(false)

// type is specified as Int, the value is at nil
var anotherVariable = Observable<Int>()
```

Creating an observer closure is also plain and simple:
```swift
model.canUndo += Listener(self) { [unowned self] (oldValue, newValue) -> Void in
  guard let canUndo = newValue else { return } // guard for nil values
  self.undoBarButtonItem.enabled = canUndo
}
```

The observing block is bound to the lifecycle of the observer, passed in the constructor of the Listener class. If the observer (in this case "self") gets deinited, the block will be removed from the list of observing closures.

The "+=" is just a convenience operator for adding listeners, there are several other ways to specify them:
```swift
// specifically adds a listener to the valueChangedEvent
m.canUndo.valueChangedEvent += Listener(self) { ... }

// add a listener by calling the method explicitly
m.canUndo.valueChangedEvent.addListener(Listener(self) { ... }
```

There are several other overloads of the "addListener" function with different signatures, I suggest you to checkout the code itself to find out more about them.

Setting a value is simple and can be done in different ways:
```swift
// set a value explicity
canUndo.value = routeHistory.count > 0 

// set a value even more explicitly
canUndo.setValue(routeHistory.count > 0, forceEventTrigger: true)

// shorthand, convenience operator to set a value
canUndo <- routeHistory.count > 0 
```

In the above example, "setValue(..., forceEventTrigger: true)" forces the value changed event to get triggered, even if the value did not change. If you set the value otherwise to the same value as it alreay is, no events get triggered.

## How to observe arrays

Creating observable arrays is similar to creating an observable objects. However, the ObservableArray class adds some convenience:

```swift
// create an observable array
var route = ObservableArray<CLLocation>()

// add a listener to it
self.route.collectionChangedEvent += CollectionListener(self) { [unowned self] (oldValue, newValue) -> Void in
  ...
}
```

ObservableArrays should have most (if not all) of the convenience a standard Array has, like subscripting (self.route[2] = ...), count (self.route.count) etc. This is all thanks to SwiftBond, as the ObservableArray was heavily inspired by theirs.

## ToDo

- [x] Add unit tests
- [ ] Add documentation (Yes I was lazy, I'll admit it.)

## How to contribute

Contributing to this project is very welcome. If you miss some functionality, either tell us about it or add it on your own by forking and submitting a pull request. You will be kept in honor by our whole company for doing so.

If you don't want that honor, you can also go ahead and ping me or anyone of my company if you miss a feature or got a nasty bug. You can also open a support ticket, we'll try to cover them as best as possible.

## Creators and Contributors

ObservableKit was created by Florian Rath while working on a project at [Codepool GmbH](http://www.codepool.at).
Currently, there are no other contributors than me and my fellow colleagues. If you want to have your name listed here, please go ahead, add a useful feature or squash some nasty bug and submit a pull request.

## License

The MIT License (MIT)

Copyright (c) 2015 Codepool GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
