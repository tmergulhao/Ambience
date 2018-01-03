# Ambience

[![CI Status](http://img.shields.io/travis/tmergulhao/Ambience.svg?style=flat)](https://travis-ci.org/tmergulhao/Ambience)
[![Version](https://img.shields.io/cocoapods/v/Ambience.svg?style=flat)](http://cocoapods.org/pods/Ambience)
[![License](https://img.shields.io/cocoapods/l/Ambience.svg?style=flat)](http://cocoapods.org/pods/Ambience)
[![Platform](https://img.shields.io/cocoapods/p/Ambience.svg?style=flat)](http://cocoapods.org/pods/Ambience)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Built-in support

Ambience has built-in support for the background color for the following Interface Builder objects:

- View and all its children;
- Search, Navigation and Tab bars and all of its children;
- Text View, Button, and Label and all of its children.

There is also support for the text color for:

- Text View, Button, and Label and all of its children.

## Custom Behaviors

It's also possible to define custom Ambience behavior on any Object that inherits from `NSObject`. Follow the instructions.

### Define an Override of the Ambience Method

In this example, we are implementing the current behavior for Search, Navigation and Tab bars. It guards the notification data for the current state as an `Ambience State` and sets the bar style accordingly.

```swift
public override func ambience(_ notification : Notification) {

super.ambience(notification)

guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }

barStyle = currentState == .invert ? .black : .default
}
```

The notification user info dictionary also comes with the previous state so that more complex stateful behaviors can be implemented. It _may_ also come with an `animated` boolean attribute the is usually set to true and, at the first run, set to false so as not to have animation upon view appearance.

### Turning Ambience On

If your object is set on **Interface Builder**, use the **Attributes Inspector** and set to **On** the **Ambience** value.

In case you are setting this object programmatically, just set its `ambience` boolean value to `true` before placing it.

## Installation

Ambience is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Ambience'
```

## Author

tmergulhao, me@tmergulhao.com

## License

Ambience is available under the MIT license. See the LICENSE file for more info.
