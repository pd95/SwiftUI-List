# SwiftUI List

The `List` view in SwiftUI is very powerful and can be easily applied. But as soon as you start to use them you will encounter some quirks.

---

In it's most simple form, a `List` view can be created in 3 lines:

```swift
List(data) { element in
    Text(element.text)
}
```

There are also many other `List` initializers available, some based on integer ranges, others based on data with associated identifier. In general it is good practice to have the element conform to `Identifiable`, i.e. it has an `id` property which is unique within the collection as our `DataWrapper` example below.

```swift
struct DataWrapper: Identifiable {
    let id = UUID()
    var text: String
}
```

Looking at the images below, we confirm that on iPhone this really os the most basic form we see in many apps. On macOS the list looks even bolder: there are even no visible dividers!

<img alt="Minimal List on iPhone" src="_images/Minimal_iPhoneSE_iOS14.png" width="300" />
<img alt="Minimal List on macOS" src="_images/Minimal_macOS11.png" width="400" />

---

## Adding Selection

If we want now to have the possibility to select a row, we have to define a state variable to store the selected row (ID) and add the `selection:` parameter to the `List` initializer:

```swift
@State private var selection: UUID?
```

```swift
List(data, selection: $selection) { element in
    Text(element.text)
}
```

On macOS this simple addition already enables the selection handling. It allows us to select a row by clicking it and move the selection with the arrow keys.

<img alt="Minimal List on macOS with selected row" src="_images/Minimal_selected_row_macOS11.png" width="400" />

On iPhone we won't see any difference yet. This is due to the fact, that the row selection elements are only visible if the list is shown in *edit mode*. Normally a user
enters into *edit mode* explicitely by tapping an "Edit" button (which would be found in a toolbar). But for our purpose it is sufficient to simulate the fact that the edit mode is activated by adding the following line at the end of our `List` content (or any parent view):

```swift
.environment(\.editMode, .constant(.active))
```

<img alt="Minimal List on iPhone with selected row" src="_images/Minimal_selected_row_iPhoneSE_iOS14.png" width="300" />

### Enable Multi-Selection

To enable **Multi-Selection** we simply have to adjust our state variable: Instead of defining space for a single selection (Optional<DataWrapper.ID>) we define it as a `Set` of our elements IDs.

```swift
@State private var selection = Set<UUID>()
```

What I really like about the macOS implementation: Out-of-the-box it supports all the possible selection modes using the keyboard modifiers to ease the selection of multiple rows (using Shift+click) and add/remove single rows to the existing selection (using CMD+click). Selection with the arrow keys is also possible!

<img alt="Minimal List on macOS with multiple rows selected" src="_images/Minimal_selected_multiple_rows_macOS11.png" width="400" />
<img alt="Minimal List on iPhone with multiple rows selected" src="_images/Minimal_selected_multiple_rows_iPhoneSE_iOS14.png" width="300" />

---

## Adding Move

Another nice feature is the built-in support for moving rows within the list by simply adding the `.onMove(perform:)` modifier. But this modifier is not applicable to the `List` view but to the `ForEach` struct, so we have to rewrite our basic list to use `ForEach` to iterate over our elements:

```swift
List(selection: $selection) {
    ForEach(data) { element in
        Text(element.text)
    }
    .onMove(perform: { indices, offset in
        withAnimation {
            data.move(fromOffsets: indices, toOffset: offset)
        }
    })
}
```

As you can see, we use the `Array`s `move` method which takes in parameter `fromOffset` an `IndexSet` with the indices of the selected rows and a `toOffset` with the target row where those have to be inserted. Just by adding this action, we enhanced our list with reordering functionality.

On macOS the availability of the reordering functionality is not visible atonce, but a Mac user commonly knows that he can select multiple lines and then drag them to their destination. Exactly how it works here.  
On the iPhone we see immediately reordering handles showing up on the right side of each line. They are independent of the selection. As a consequence, it is only possible to move one line at the a time.  

<img alt="List moving multiple rows on macOS" src="_images/List_moving_row_macOS11.gif" width="400" />
<img alt="List on iPhone with row reordering UI" src="_images/List_moving_row_iPhoneSE_iOS14.png" width="300" />

---

## Adding Swipe to Delete

After having split the basic `List` into a `List` container and a `ForEach` iterator, it is an easy exercise to add **swipe to delete** as we have to add only another modifier to the `ForEach` struct: `.onDelete(perform:)`

```swift
List(selection: $selection) {
    ForEach(data) { element in
        Text(element.text)
    }
    .onDelete(perform: { indices in
        withAnimation {
            data.remove(atOffsets: indices)
        }
    })
}
```

When testing this, it becomes immediately visible that swipe to delete is really intended to be applied to a single row: it ignores any selection. Even more: on **iPhone it basically does not work as long as the list is in edit mode**. This means selection & reordering are mutually exclusive to "swipe to delete". If you want to provide a deletion functionality based on the current selection, you will have to add a custom delete button to the toolbar.

<img alt="List deleting rows on macOS using 'swipe to delete'" src="_images/List_deleting_rows_macOS11.gif" width="400" />
<img alt="List deleting rows on iPhone using 'swipe to delete'" src="_images/List_deleting_rows_iPhoneSE_iOS14.gif" width="300" />

---

## Adding groups/sections

To group similar data visually within a list, it is possible to create sections with headers and footers. While scrolling through a bigger list, the current section header will always stay visible.

```swift
List(selection: $selection) {
    Section(header: Text("Top 3"),
            footer: Text("All this gibberish can be ignored, even though it seems to be some latin dialect it is absolute nonsense.")
                .font(.caption)
    ) {
        ForEach(data.prefix(3)) { element in
            Text(element.text)
        }
    }
    Section(header: Text("Rest")) {
        ForEach(data.dropFirst(3)) { element in
            Text(element.text)
        }
    }
}
```

Be aware: **you cannot move elements between different sections!**

As you can see on the screenshot below, the section header and footers on macOS Big Sur are easily overlooked in the default styling. For the iPhone we see again a known default style for headers.

<img alt="List with sections on macOS" src="_images/List_grouped_in_sections_macOS11.png" width="400" />
<img alt="List with sections on iPhone" src="_images/List_grouped_in_sections_iPhoneSE_iOS14.png" width="300" />

---

## Applying list styles

The lists can be styled using one of the following `ListStyle`s

- `PlainListStyle` / `.plain`
- `InsetListStyle` / `.inset`
- `GroupedListStyle` / `.grouped` : iOS only
- `InsetGroupedListStyle` / `.insetGrouped` : iOS only
- `SidebarListStyle` / `.sidebar`
- `BorderedListStyle` / `.bordered` : macOS 12 only

List styles have to be applied onto the `List` by adding for the modifier `.listStyle()` with the appropriate style. Before Swift 5.5 you had to instanciate the list style using for example `InsetGroupedListStyle()`. But with Swift 5.5 better inference for type erased generics has been added and we can now write `.insetGrouped`.

Below are a few screenshots for different list styles on iPhone.

<img alt="List with PlainListStyle on iPhone" src="_images/ListStyle_Plain_iPhoneSE_iOS14.png" width="300" />

<img alt="List with InsetListStyle on iPhone" src="_images/ListStyle_Inset_iPhoneSE_iOS14.png" width="300" />

<img alt="List with GroupedListStyle on iPhone" src="_images/ListStyle_Grouped_iPhoneSE_iOS14.png" width="300" />

<img alt="List with InsetGroupedListStyle on iPhone" src="_images/ListStyle_InsetGrouped_iPhoneSE_iOS14.png" width="300" />

<img alt="List with SidebarListStyle on iPhone" src="_images/ListStyle_Sidebar_iPhoneSE_iOS14.png" width="300" />


---

## List Row Background - the nightmare begins

When you start to use `List` in more and more sophisticated ways, you will sooner or later feel the desire to change the background color of a row. First you will try to use `.background(Color.orange)` on the row content, but you will then realize that this will only affect the content drawn into the "cell". There is still white space arround your content which is not managed by your row content. This is especially visible when row selection is enabled, as shown below:  

```swift
Text(element.text)
    .background(Color.orange)
````

<img alt="List content background not covering complete row" src="_images/List_no_background_color_macOS11.png" width="400" />

This is where the modifier `.listRowBackground()` comes into play. By using `.listRowBackground(Color.orange)` on your row content, you will see the white space diminish, but you will see that it probably does not work with selection in mind: our row backround is overwriting the macOS selection color as shown below:

```swift
Text(element.text)
    .listRowBackground(Color.orange)
````

<img alt="List row background with custom color, but drawing over selection color" src="_images/List_row_background_color_macOS11.png" width="400" />

One possible workaround is not drawing the background color when the row is selected!

```swift
Text(element.text)
    .listRowBackground(Group {
        if selection.contains(element.id) == false {
            Color.orange
        }
    })
```

But as you see below, that's not supported. Now only an empty selection is drawn without our row content!

<img alt="List row background not using color on selected rows" src="_images/List_row_background_color_broken_selection_macOS11.png" width="400" />

The fix for this problem: Just draw `Color.clear` when the row is selected and `Color.orange` otherwise.

```swift
Text(element.text)
    .listRowBackground(Group {
        if selection.contains(element.id){
            Color.clear
        } else {
            Color.orange
        }
    })
```

Finally: our background color is correctly applied and does not interfere with the selection!

<img alt="List row background using custom background color and correct selection color" src="_images/List_row_background_color_working_selection_macOS11.png" width="400" />

As we have now fixed the list selection, we start to reorder rows again. Now this feature is also broken!

As illustrated below, moving rows will make their height resize randomly!

<img alt="List row background using custom background color and correct selection color" src="_images/List_row_random_height_after_move_macOS11.gif" width="400" />

## The nightmare continues

(but there will be a solution!)