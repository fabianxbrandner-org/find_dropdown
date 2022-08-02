library find_dropdown;

import 'package:select_dialog/select_dialog.dart';
import 'package:flutter/material.dart';

import 'find_dropdown_bloc.dart';
import 'validation_message_widget.dart';

/// Callback to be triggered when element is found
typedef FindDropdownFindType<T> = Future<List<T>> Function(String text);
// ignore: public_member_api_docs
typedef FindDropdownChangedType<T> = void Function(T? selectedItem);
// ignore: public_member_api_docs
typedef FindDropdownMultipleItemsChangedType<T> = void Function(List<T> selectedItem);

/// validation function for selection
typedef FindDropdownValidation<T> = String? Function(T? selectedText);

/// Builder function for single item selections
typedef FindDropdownBuilder<T> = Widget Function(BuildContext context, T? selectedItem);

/// Builder function for multi item selections
typedef FindDropdownMultipleItemsBuilder<T> = Widget Function(BuildContext context, List<T> selectedItem);

/// Builder function for rendering items
typedef FindDropdownItemBuilder<T> = Widget Function(BuildContext context, T item, bool isSelected);

/// Dropdown with a search field
class FindDropdown<T> extends StatefulWidget {
  /// The label to be displayed
  final String? label;

  /// if the label should be visible
  final bool labelVisible;

  /// if a clear button should be rendered
  final bool showClearButton;

  /// the textstyle of the label
  final TextStyle? labelStyle;

  /// the items
  final List<T>? items;

  /// the selected item
  final T? selectedItem;

  /// a list of selected items
  final List<T>? multipleSelectedItems;

  /// function to be triggered when elements are found
  final FindDropdownFindType<T>? onFind;

  /// function to be triggered when selection changed
  final FindDropdownChangedType<T>? onChanged;

  /// function to be triggered when list of selections changed
  final FindDropdownMultipleItemsChangedType<T>? onMultipleItemsChanged;

  /// The dropdown builder function for single item selections
  final FindDropdownBuilder<T>? dropdownBuilder;

  /// The dropdown builder function for multi item selections
  final FindDropdownMultipleItemsBuilder<T>? dropdownMultipleItemsBuilder;

  /// builder function for displaying the items
  final FindDropdownItemBuilder<T>? dropdownItemBuilder;

  /// validation function for single item selection
  final FindDropdownValidation<T>? validate;

  /// validation function for multi item selection
  final FindDropdownValidation<List<T>>? validateMultipleItems;

  /// The background color of the dialog
  final Color? backgroundColor;

  /// Builder that is used if no items are available
  final WidgetBuilder? emptyBuilder;

  /// Builder that is used when the dialog is in loading state
  final WidgetBuilder? loadingBuilder;

  /// builder that is used to build errors
  final ErrorBuilderType? errorBuilder;

  /// if the dialog should be autofocused
  final bool? autofocus;

  /// the max lines for the search box
  final int? searchBoxMaxLines;

  /// the max lines for the search box
  final int? searchBoxMinLines;

  /// builder for the ok Button widget
  final ButtonBuilderType? okButtonBuilder;

  /// the search hint to be displayed
  @Deprecated("Use 'hintText' property from searchBoxDecoration")
  final String? searchHint;

  /// if the seachbox should be shown
  final bool showSearchBox;

  /// The decoration for the search box
  final InputDecoration? searchBoxDecoration;

  /// the text style for the title
  final TextStyle? titleStyle;

  ///|**Max width**: 90% of screen width|**Max height**: 70% of screen height|
  ///|---|---|
  ///|![image](https://user-images.githubusercontent.com/16373553/80189438-0a020480-85e9-11ea-8e63-3fabfa42c1c7.png)|![image](https://user-images.githubusercontent.com/16373553/80190562-e2ac3700-85ea-11ea-82ef-3383ae32ab02.png)|
  final BoxConstraints? constraints;

  /// uses the dropdown with multiselect mode
  const FindDropdown.multiSelect({
    Key? key,
    required FindDropdownMultipleItemsChangedType<T> onChanged,
    this.label,
    this.labelStyle,
    this.items,
    List<T>? selectedItems,
    this.onFind,
    FindDropdownMultipleItemsBuilder<T>? dropdownBuilder,
    this.dropdownItemBuilder,
    this.showSearchBox = true,
    this.showClearButton = false,
    FindDropdownValidation<List<T>>? validate,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.titleStyle,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.constraints,
    this.autofocus,
    this.searchBoxMaxLines,
    this.searchBoxMinLines,
    this.okButtonBuilder,
    this.labelVisible = true,
    @Deprecated("Use 'hintText' property from searchBoxDecoration") this.searchHint,
  })  : dropdownMultipleItemsBuilder = dropdownBuilder,
        multipleSelectedItems = selectedItems,
        onMultipleItemsChanged = onChanged,
        validateMultipleItems = validate,
        validate = null,
        dropdownBuilder = null,
        selectedItem = null,
        onChanged = null,
        super(key: key);

  /// uses the ddropdown in sindle selection mode
  const FindDropdown({
    Key? key,
    required this.onChanged,
    this.label,
    this.labelStyle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownBuilder,
    this.dropdownItemBuilder,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.validate,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.titleStyle,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.constraints,
    this.autofocus,
    this.searchBoxMaxLines,
    this.searchBoxMinLines,
    this.okButtonBuilder,
    this.labelVisible = true,
    @Deprecated("Use 'hintText' property from searchBoxDecoration") this.searchHint,
  })  : validateMultipleItems = null,
        dropdownMultipleItemsBuilder = null,
        multipleSelectedItems = null,
        onMultipleItemsChanged = null,
        super(key: key);

  @override
  FindDropdownState<T> createState() => FindDropdownState<T>();
}

/// the state of the dropdown
class FindDropdownState<T> extends State<FindDropdown<T>> {
  late FindDropdownBloc _bloc;

  /// if multi select mode is used
  bool get isMultipleItems => widget.onMultipleItemsChanged != null;

  /// sets the selected item
  void setSelectedItem(dynamic item) {
    if (isMultipleItems) assert(item is List<T>);
    if (!isMultipleItems) assert(item == null || item is T);
    _bloc.selected$.add(item);
  }

  @override
  void initState() {
    super.initState();
    if (isMultipleItems) {
      _bloc = FindDropdownBloc<List<T>>(
        seedValue: widget.multipleSelectedItems ?? [],
        validate: widget.validateMultipleItems,
      );
    } else {
      _bloc = FindDropdownBloc<T>(
        seedValue: widget.selectedItem,
        validate: widget.validate,
      );
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null && widget.labelVisible)
          Text(widget.label!, style: widget.labelStyle ?? Theme.of(context).textTheme.subtitle1),
        if (widget.label != null) const SizedBox(height: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: _bloc.selected$,
              builder: (context, snapshot) {
                List<T>? multipleSelectedValues;
                if (isMultipleItems) {
                  multipleSelectedValues = snapshot.data as List<T>?;
                }

                T? selectedValue;
                if (!isMultipleItems) selectedValue = snapshot.data as T?;

                return GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<T>(
                      context,
                      items: widget.items,
                      label: widget.label,
                      onFind: widget.onFind,
                      multipleSelectedValues: multipleSelectedValues,
                      okButtonBuilder: widget.okButtonBuilder,
                      showSearchBox: widget.showSearchBox,
                      itemBuilder: widget.dropdownItemBuilder,
                      selectedValue: selectedValue,
                      searchBoxDecoration: widget.searchBoxDecoration,
                      backgroundColor: widget.backgroundColor,
                      titleStyle: widget.titleStyle,
                      autofocus: widget.autofocus ?? false,
                      constraints: widget.constraints,
                      emptyBuilder: widget.emptyBuilder,
                      errorBuilder: widget.errorBuilder,
                      loadingBuilder: widget.loadingBuilder,
                      searchBoxMaxLines: widget.searchBoxMaxLines ?? 1,
                      searchBoxMinLines: widget.searchBoxMinLines ?? 1,
                      onMultipleItemsChange: isMultipleItems
                          ? (items) {
                              _bloc.selected$.add(items);
                              widget.onMultipleItemsChanged?.call(items);
                            }
                          : null,
                      onChange: isMultipleItems
                          ? null
                          : (item) {
                              _bloc.selected$.add(item);
                              widget.onChanged?.call(item);
                            },
                    );
                  },
                  child: widget.dropdownBuilder?.call(context, selectedValue) ??
                      widget.dropdownMultipleItemsBuilder?.call(context, multipleSelectedValues ?? []) ??
                      Builder(builder: (context) {
                        String? title = isMultipleItems ? multipleSelectedValues?.join(', ').toString() : snapshot.data?.toString();
                        bool showClearButton = snapshot.data != null && widget.showClearButton;
                        return Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(title ?? ''),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    if (showClearButton)
                                      GestureDetector(
                                        onTap: () {
                                          _bloc.selected$.add(null);
                                          widget.onChanged?.call(null);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 0),
                                          child: Icon(Icons.clear, size: 25, color: Colors.black54),
                                        ),
                                      ),
                                    if (!showClearButton) const Icon(Icons.arrow_drop_down, size: 25, color: Colors.black54),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
            if (widget.validate != null || widget.validateMultipleItems != null) ValidationMessageWidget(bloc: _bloc),
          ],
        ),
      ],
    );
  }
}
