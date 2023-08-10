// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// Strategies for adapting a presentation to a different size class.
///
/// Use values of this type with the ``View/presentationCompactAdaptation(_:)``
/// and ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifiers.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationAdaptation : Sendable {

    /// Use the default presentation adaptation.
    public static var automatic: PresentationAdaptation { get { fatalError() } }

    /// Don't adapt for the size class, if possible.
    public static var none: PresentationAdaptation { get { fatalError() } }

    /// Prefer a popover appearance when adapting for size classes.
    public static var popover: PresentationAdaptation { get { fatalError() } }

    /// Prefer a sheet appearance when adapting for size classes.
    public static var sheet: PresentationAdaptation { get { fatalError() } }

    /// Prefer a full-screen-cover appearance when adapting for size classes.
    public static var fullScreenCover: PresentationAdaptation { get { fatalError() } }
}

/// The kinds of interaction available to views behind a presentation.
///
/// Use values of this type with the
/// ``View/presentationBackgroundInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationBackgroundInteraction : Sendable {

    /// The default background interaction for the presentation.
    public static var automatic: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation.
    public static var enabled: PresentationBackgroundInteraction { get { fatalError() } }

    /// People can interact with the view behind a presentation up through a
    /// specified detent.
    ///
    /// At detents larger than the one you specify, SkipUI disables
    /// interaction.
    ///
    /// - Parameter detent: The largest detent at which people can interact with
    ///   the view behind the presentation.
    public static func enabled(upThrough detent: PresentationDetent) -> PresentationBackgroundInteraction { fatalError() }

    /// People can't interact with the view behind a presentation.
    public static var disabled: PresentationBackgroundInteraction { get { fatalError() } }
}

/// A behavior that you can use to influence how a presentation responds to
/// swipe gestures.
///
/// Use values of this type with the
/// ``View/presentationContentInteraction(_:)`` modifier.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct PresentationContentInteraction : Equatable, Sendable {

    /// The default swipe behavior for the presentation.
    public static var automatic: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes resizing a presentation when swiping, rather
    /// than scrolling the content of the presentation.
    public static var resizes: PresentationContentInteraction { get { fatalError() } }

    /// A behavior that prioritizes scrolling the content of a presentation when
    /// swiping, rather than resizing the presentation.
    public static var scrolls: PresentationContentInteraction { get { fatalError() } }

    public static func == (a: PresentationContentInteraction, b: PresentationContentInteraction) -> Bool { fatalError() }
}

/// A type that represents a height where a sheet naturally rests.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct PresentationDetent : Hashable, Sendable {

    /// The system detent for a sheet that's approximately half the height of
    /// the screen, and is inactive in compact height.
    public static let medium: PresentationDetent = { fatalError() }()

    /// The system detent for a sheet at full height.
    public static let large: PresentationDetent = { fatalError() }()

    /// A custom detent with the specified fractional height.
    public static func fraction(_ fraction: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with the specified height.
    public static func height(_ height: CGFloat) -> PresentationDetent { fatalError() }

    /// A custom detent with a calculated height.
    public static func custom<D>(_ type: D.Type) -> PresentationDetent where D : CustomPresentationDetent { fatalError() }

    /// Information that you use to calculate the presentation's height.
    @dynamicMemberLookup public struct Context {

        /// The height that the presentation appears in.
        public var maxDetentValue: CGFloat { get { fatalError() } }

        /// Returns the value specified by the keyPath from the environment.
        ///
        /// This uses the environment from where the sheet is shown, not the
        /// environment where the presentation modifier is applied.
        public subscript<T>(dynamicMember keyPath: KeyPath<EnvironmentValues, T>) -> T { get { fatalError() } }
    }

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: PresentationDetent, b: PresentationDetent) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

/// An indication whether a view is currently presented by another view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use EnvironmentValues.isPresented or EnvironmentValues.dismiss")
public struct PresentationMode {

    /// Indicates whether a view is currently presented.
    public var isPresented: Bool { get { fatalError() } }

    /// Dismisses the view if it is currently presented.
    ///
    /// If `isPresented` is false, `dismiss()` is a no-op.
    public mutating func dismiss() { fatalError() }
}

/// A view that represents the content of a presented window.
///
/// You don't create this type directly. ``WindowGroup`` creates values for you.
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct PresentedWindowContent<Data, Content> : View where Data : Decodable, Data : Encodable, Data : Hashable, Content : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}