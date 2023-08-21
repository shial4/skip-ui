// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A set of key modifiers that you can add to a gesture.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EventModifiers : OptionSet {

    /// The raw value.
    public let rawValue: Int = { fatalError() }()

    /// Creates a new set from a raw value.
    ///
    /// - Parameter rawValue: The raw value with which to create the key
    ///   modifier.
    public init(rawValue: Int) { fatalError() }

    /// The Caps Lock key.
    public static let capsLock: EventModifiers = { fatalError() }()

    /// The Shift key.
    public static let shift: EventModifiers = { fatalError() }()

    /// The Control key.
    public static let control: EventModifiers = { fatalError() }()

    /// The Option key.
    public static let option: EventModifiers = { fatalError() }()

    /// The Command key.
    public static let command: EventModifiers = { fatalError() }()

    /// Any key on the numeric keypad.
    public static let numericPad: EventModifiers = { fatalError() }()

    /// The Function key.
    @available(iOS, deprecated: 15.0, message: "Function modifier is reserved for system applications")
    @available(macOS, deprecated: 12.0, message: "Function modifier is reserved for system applications")
    @available(tvOS, deprecated: 15.0, message: "Function modifier is reserved for system applications")
    @available(watchOS, deprecated: 8.0, message: "Function modifier is reserved for system applications")
    @available(xrOS, deprecated: 1.0, message: "Function modifier is reserved for system applications")
    public static let function: EventModifiers = { fatalError() }()

    /// All possible modifier keys.
    public static let all: EventModifiers = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = EventModifiers

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = EventModifiers

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EventModifiers : Sendable {
}

#endif
