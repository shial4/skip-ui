// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import struct CoreGraphics.CGFloat
#endif

// SKIP INSERT: import androidx.compose.foundation.verticalScroll
// SKIP INSERT: import androidx.compose.foundation.layout.fillMaxWidth
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.ui.unit.dp

// Erase the SelectionValue because it is currently unused in Kotlin, the compiler won't be able to calculate it
//
// SKIP DECLARE: class List<Content>: View where Content: View
public struct List<SelectionValue, Content> : View where SelectionValue: Hashable, Content : View {
    let fixedContent: Content?
    let indexedContent: ((Int) -> Content)?
    let indexRange: Range<Int>?
    let objectContent: ((Any) -> Content)?
    let objects: (any RandomAccessCollection<Any>)?
    let identifier: ((Any) -> AnyHashable)?

    init(fixedContent: Content? = nil, indexRange: Range<Int>? = nil, indexedContent: ((Int) -> Content)? = nil, objects: (any RandomAccessCollection<Any>)? = nil, identifier: ((Any) -> AnyHashable)? = nil, objectContent: ((Any) -> Content)? = nil) {
        self.fixedContent = fixedContent
        self.indexRange = indexRange
        self.indexedContent = indexedContent
        self.objects = objects
        self.identifier = identifier
        self.objectContent = objectContent
    }

    public init(@ViewBuilder content: () -> Content) {
        self.init(fixedContent: content())
    }

    @available(*, unavailable)
    public init(selection: Binding<Any>, @ViewBuilder content: () -> Content) {
        self.init(fixedContent: content())
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let modifier = androidx.compose.ui.Modifier.fillMaxWidth().then(context.modifier)
        let itemContext = context.content(of: self)
        if let fixedContent {
            let scrollState = androidx.compose.foundation.rememberScrollState()
            androidx.compose.foundation.layout.Column(modifier: modifier.verticalScroll(scrollState), verticalArrangement: androidx.compose.foundation.layout.Arrangement.spacedBy(8.0.dp), horizontalAlignment: androidx.compose.ui.Alignment.Start) {
                fixedContent.Compose(context: itemContext)
            }
        } else if let indexRange {
            androidx.compose.foundation.lazy.LazyColumn(modifier: modifier, verticalArrangement: androidx.compose.foundation.layout.Arrangement.spacedBy(8.0.dp), horizontalAlignment: androidx.compose.ui.Alignment.Start) {
                items(indexRange.endExclusive - indexRange.start) {
                    indexedContent!(indexRange.start + $0).Compose(context: itemContext)
                }
            }
        } else if let objects {
            androidx.compose.foundation.lazy.LazyColumn(modifier: modifier, verticalArrangement: androidx.compose.foundation.layout.Arrangement.spacedBy(8.0.dp), horizontalAlignment: androidx.compose.ui.Alignment.Start) {
                items(count: objects.count, key: { identifier!(objects[$0]) }) {
                    objectContent!(objects[$0]).Compose(context: itemContext)
                }
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}


extension List {
    public init(_ data: Range<Int>, @ViewBuilder rowContent: @escaping (Int) -> Content) {
        self.init(indexRange: data, indexedContent: rowContent)
    }
}

// Kotlin does not support generic constructor parameters, so we have to model many List constructors as functions

//extension List {
//    public init<Data, RowContent>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable
//}
// SKIP INSERT:
// fun <ObjectType, Content> List(data: RandomAccessCollection<ObjectType>, rowContent: (ObjectType) -> Content): List<Content> where ObjectType: Identifiable<Hashable>, Content: View {
//      return List(objects = data as RandomAccessCollection<Any>, identifier = { (it as ObjectType).id }, objectContent = { rowContent(it as ObjectType) })
// }

//extension List {
//    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View
//}
// SKIP INSERT:
// fun <ObjectType, Content> List(data: RandomAccessCollection<ObjectType>, id: (ObjectType) -> Hashable, rowContent: (ObjectType) -> Content): List<Content> where Content: View {
//      return List(objects = data as RandomAccessCollection<Any>, identifier = { id(it as ObjectType) }, objectContent = { rowContent(it as ObjectType) })
// }

#if !SKIP

// TODO: Process for use in SkipUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select multiple rows.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-9a28m``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS 10.0, *)
    @MainActor public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS 10.0, *)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a list that computes its views on demand over a constant range,
    /// optionally allowing users to select a single row.
    ///
    /// This instance only reads the initial value of `data` and doesn't need to
    /// identify views across updates. To compute views on demand over a dynamic
    /// range, use ``List/init(_:id:selection:rowContent:)-2r2u9``.
    ///
    /// - Parameters:
    ///   - data: A constant range of data to populate the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, RowContent>, RowContent : View { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List where SelectionValue == Never {
    /// Creates a hierarchical list that computes its rows on demand from an
    /// underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(iOS 14.0, macOS 11.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select
    /// multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data, optionally allowing users to select a
    /// single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension List where SelectionValue == Never {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that identifies its rows based on a key path to the
    /// identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, RowContent>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes an element
    ///     capable of having children that's currently childless, such as an
    ///     empty directory in a file system. On the other hand, if the property
    ///     at the key path is `nil`, then the outline group treats `data` as a
    ///     leaf in the tree, like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select multiple rows.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data, optionally
    /// allowing users to select a single row.
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data, optionally allowing users to
    /// select a single row.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension List where SelectionValue == Never {

    /// Creates a hierarchical list that computes its rows on demand from a
    /// binding to an underlying collection of identifiable data.
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable { fatalError() }

    /// Creates a hierarchical list that identifies its rows based on a key path
    /// to the identifier of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - id: The key path to the data model's identifier.
    ///   - children: A key path to a property whose non-`nil` value gives the
    ///     children of `data`. A non-`nil` but empty value denotes a node capable
    ///     of having children that is currently childless, such as an empty
    ///     directory in a file system. On the other hand, if the property at the
    ///     key path is `nil`, then `data` is treated as a leaf node in the tree,
    ///     like a regular file in a file system.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, children: WritableKeyPath<Data.Element, Data?>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == OutlineGroup<Binding<Data>, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable, allows to edit the collection, and
    /// optionally allows users to select multiple rows.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select multiple elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFoods
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing and to be edited by
    ///     the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, selection: Binding<Set<SelectionValue>>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data, allows to edit the collection, and
    /// optionally allowing users to select a single row.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection, and select a single elements.
    ///
    ///     List(
    ///         $foods,
    ///         editActions: [.delete, .move],
    ///         selection: $selectedFood
    ///     ) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - selection: A binding to a selected value.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @available(watchOS, unavailable)
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, selection: Binding<SelectionValue?>?, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension List where SelectionValue == Never {

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data and allows to edit the collection.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection.
    ///
    ///     List($foods, editActions: [.delete, .move]) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, RowContent>(_ data: Binding<Data>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, Data.Element.ID>, Data.Element.ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable, Data.Index : Hashable { fatalError() }

    /// Creates a list that computes its rows on demand from an underlying
    /// collection of identifiable data and allows to edit the collection.
    ///
    /// The following example creates a list to display a collection of favorite
    /// foods allowing the user to delete or move elements from the
    /// collection.
    ///
    ///     List($foods, editActions: [.delete, .move]) { $food in
    ///        HStack {
    ///            Text(food.name)
    ///            Toggle("Favorite", isOn: $food.isFavorite)
    ///        }
    ///     }
    ///
    /// Use ``View/deleteDisabled(_:)`` and ``View/moveDisabled(_:)``
    /// to disable respectively delete or move actions on a per-row basis.
    ///
    /// Explicit ``DynamicViewContent.onDelete(perform:)``,
    /// ``DynamicViewContent.onMove(perform:)``, or
    /// ``View.swipeActions(edge:allowsFullSwipe:content:)``
    /// modifiers will override any synthesized action
    ///
    /// - Parameters:
    ///   - data: A collection of identifiable data for computing the list.
    ///   - id: The key path to the data model's identifier.
    ///   - editActions: The edit actions that are synthesized on `data`.
    ///   - rowContent: A view builder that creates the view for a single row of
    ///     the list.
    @MainActor public init<Data, ID, RowContent>(_ data: Binding<Data>, id: KeyPath<Data.Element, ID>, editActions: EditActions<Data>, @ViewBuilder rowContent: @escaping (Binding<Data.Element>) -> RowContent) where Content == ForEach<IndexedIdentifierCollection<Data, ID>, ID, EditableCollectionContent<RowContent, Data>>, Data : MutableCollection, Data : RandomAccessCollection, ID : Hashable, RowContent : View, Data.Index : Hashable { fatalError() }
}

/// The configuration of a tint effect applied to content within a List.
///
/// - See Also: `View.listItemTint(_:)`
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ListItemTint : Sendable {

    /// An explicit tint color.
    ///
    /// This tint effect is fixed and not overridable by other
    /// system effects.
    public static func fixed(_ tint: Color) -> ListItemTint { fatalError() }

    /// An explicit tint color that is overridable.
    ///
    /// This tint effect is overridable by system effects, for
    /// example when the system has a custom user accent
    /// color on macOS.
    public static func preferred(_ tint: Color) -> ListItemTint { fatalError() }

    /// A standard grayscale tint effect.
    ///
    /// Monochrome tints are not overridable.
    public static let monochrome: ListItemTint = { fatalError() }()
}

/// The spacing options between two adjacent sections in a list.
@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public struct ListSectionSpacing : Sendable {

    /// The default spacing between sections
    public static let `default`: ListSectionSpacing = { fatalError() }()

    /// Compact spacing between sections
    public static let compact: ListSectionSpacing = { fatalError() }()

    /// Creates a custom spacing value.
    ///
    /// - Parameter spacing: the amount of spacing to use.
    public static func custom(_ spacing: CGFloat) -> ListSectionSpacing { fatalError() }
}

/// A protocol that describes the behavior and appearance of a list.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ListStyle {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ListStyle where Self == DefaultListStyle {

    /// The list style that describes a platform's default behavior and
    /// appearance for a list.
    public static var automatic: DefaultListStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == SidebarListStyle {

    /// The list style that describes the behavior and appearance of a
    /// sidebar list.
    ///
    /// On macOS and iOS, the sidebar list style displays disclosure indicators in
    /// the section headers that allow the user to collapse and expand sections.
    public static var sidebar: SidebarListStyle { get { fatalError() } }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == InsetGroupedListStyle {

    /// The list style that describes the behavior and appearance of an inset
    /// grouped list.
    ///
    /// On iOS, the inset grouped list style displays a continuous background color
    /// that extends from the section header, around both sides of list items in the
    /// section, and down to the section footer. This visually groups the items
    /// to a greater degree than either the ``ListStyle/inset`` or
    /// ``ListStyle/grouped`` styles do.
    public static var insetGrouped: InsetGroupedListStyle { get { fatalError() } }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == GroupedListStyle {

    /// The list style that describes the behavior and appearance of a grouped
    /// list.
    ///
    /// On iOS, the grouped list style displays a larger header and footer than
    /// the ``ListStyle/plain`` style, which visually distances the members of
    /// different sections.
    public static var grouped: GroupedListStyle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension ListStyle where Self == InsetListStyle {

    /// The list style that describes the behavior and appearance of an inset
    /// list.
    public static var inset: InsetListStyle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ListStyle where Self == PlainListStyle {

    /// The list style that describes the behavior and appearance of a plain
    /// list.
    public static var plain: PlainListStyle { get { fatalError() } }
}

/// The list style that describes the behavior and appearance of a grouped list.
///
/// You can also use ``ListStyle/grouped`` to construct this style.
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct GroupedListStyle : ListStyle {

    /// Creates a grouped list style.
    public init() { fatalError() }
}

/// The list style that describes a platform's default behavior and appearance
/// for a list.
///
/// You can also use ``ListStyle/automatic`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DefaultListStyle : ListStyle {

    /// Creates a default list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of an inset
/// grouped list.
///
/// You can also use ``ListStyle/insetGrouped`` to construct this style.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InsetGroupedListStyle : ListStyle {

    /// Creates an inset grouped list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of an inset list.
///
/// You can also use ``ListStyle/inset`` to construct this style.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct InsetListStyle : ListStyle {

    /// Creates an inset list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of a plain list.
///
/// You can also use ``ListStyle/plain`` to construct this style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PlainListStyle : ListStyle {

    /// Creates a plain list style.
    public init() { fatalError() }
}

/// The list style that describes the behavior and appearance of a
/// sidebar list.
///
/// You can also use ``ListStyle/sidebar`` to construct this style.
@available(iOS 14.0, macOS 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SidebarListStyle : ListStyle {

    /// Creates a sidebar list style.
    public init() { fatalError() }
}


@available(iOS 17.0, watchOS 10.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Sets the spacing between adjacent sections in a List.
    ///
    /// Pass `.default` for the default spacing, or use `.compact` for
    /// a compact appearance between sections.
    ///
    /// The following example creates a List with compact spacing between
    /// sections:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///     .listSectionSpacing(.compact)
    @inlinable public func listSectionSpacing(_ spacing: ListSectionSpacing) -> some View { return stubView() }


    /// Sets the spacing to a custom value between adjacent sections in a List.
    ///
    /// The following example creates a List with 5 pts of spacing between
    /// sections:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///     .listSectionSpacing(5.0)
    ///
    /// Spacing can also be specified on a per-section basis. The following
    /// example creates a List with compact spacing for its second section:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Borders") {
    ///             Text("Dashed")
    ///             Text("Solid")
    ///         }
    ///         .listSectionSpacing(.compact)
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///
    /// If adjacent sections have different spacing value, the smaller value on
    /// the shared edge is used. Spacing specified inside the List is preferred
    /// over any List-wide value.
    ///
    /// - Parameter spacing: the amount of spacing to apply.
    @inlinable public func listSectionSpacing(_ spacing: CGFloat) -> some View { return stubView() }

}

#endif