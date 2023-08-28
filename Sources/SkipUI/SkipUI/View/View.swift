// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.foundation.background
// SKIP INSERT: import androidx.compose.foundation.border
// SKIP INSERT: import androidx.compose.foundation.layout.height
// SKIP INSERT: import androidx.compose.foundation.layout.padding
// SKIP INSERT: import androidx.compose.foundation.layout.width
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.ui.Modifier
// SKIP INSERT: import androidx.compose.ui.draw.alpha
// SKIP INSERT: import androidx.compose.ui.draw.rotate
// SKIP INSERT: import androidx.compose.ui.draw.scale
// SKIP INSERT: import androidx.compose.ui.platform.testTag
// SKIP INSERT: import androidx.compose.ui.semantics.contentDescription
// SKIP INSERT: import androidx.compose.ui.semantics.semantics
// SKIP INSERT: import androidx.compose.ui.unit.dp

public protocol View {
    #if SKIP
    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    /// Compose this view without an existing context - typically called when integrating a SwiftUI view tree into pure Compose.
    @Composable public func Compose() {
        Compose(context: ComposeContext())
    }

    /// Calls to `Compose` are added by the transpiler.
    @Composable public func Compose(context: ComposeContext) {
        if let parent = context.parent {
            parent.ComposeContent(view: self, context: context)
        } else {
            ComposeContent(context: context)
        }
    }

    /// Compose this view's content.
    @Composable public func ComposeContent(context: ComposeContext) {
        var context = context
        context.parent = self
        body.ComposeContent(context)
    }

    /// Called on parent views to optionally influence how their children are composed.
    ///
    /// E.g. a `List` placing its child views into rows with separators.
    @Composable public func ComposeContent(view: any View, context: ComposeContext) {
        view.ComposeContent(context: context)
    }
}
#endif

#if !SKIP

// Stubs needed to compile this package:

extension Optional : View where Wrapped : View {
    public var body: some View {
        stubView()
    }
}

extension Never : View {
}
#endif