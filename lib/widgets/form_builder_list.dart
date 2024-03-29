import 'dart:core';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Field for List button
class FormBuilderList extends FormBuilderField<List<String>> {
  /// The list of items the user can select.
  ///
  /// If the [onChanged] callback is null or the list of items is null
  /// then the List button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input. A disabled button
  /// will display the [disabledHint] widget if it is non-null. If
  /// [disabledHint] is also null but [hint] is non-null, [hint] will instead
  /// be displayed.
  // final List<String> items;

  /// A placeholder widget that is displayed by the List button.
  ///
  /// If [value] is null, this widget is displayed as a placeholder for
  /// the List button's value. This widget is also displayed if the button
  /// is disabled ([items] or [onChanged] is null) and [disabledHint] is null.
  final Widget? hint;

  /// A message to show when the List is disabled.
  ///
  /// Displayed if [items] or [onChanged] is null. If [hint] is non-null and
  /// [disabledHint] is null, the [hint] widget will be displayed instead.
  final Widget? disabledHint;

  /// Called when the List button is tapped.
  ///
  /// This is distinct from [onChanged], which is called when the user
  /// selects an item from the List.
  ///
  /// The callback will not be invoked if the List button is disabled.
  final VoidCallback? onTap;

  /// A builder to customize the List buttons corresponding to the
  /// [ListMenuItem]s in [items].
  ///
  /// When a [ListMenuItem] is selected, the widget that will be displayed
  /// from the list corresponds to the [ListMenuItem] of the same index
  /// in [items].
  ///
  /// {@tool dartpad --template=stateful_widget_scaffold}
  ///
  /// This sample shows a `ListButton` with a button with [Text] that
  /// corresponds to but is unique from [ListMenuItem].
  ///
  /// If this callback is null, the [ListMenuItem] from [items]
  /// that matches [value] will be displayed.

  /// The z-coordinate at which to place the menu when open.
  ///
  /// The following elevations have defined shadows: 1, 2, 3, 4, 6, 8, 9, 12,
  /// 16, and 24. See [kElevationToShadow].
  ///
  /// Defaults to 8, the appropriate elevation for List buttons.
  final int elevation;

  /// The text style to use for text in the List button and the List
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the List button, consider using [selectedItemBuilder].
  ///
  /// {@tool dartpad --template=stateful_widget_scaffold}
  ///
  /// This sample shows a `ListButton` with a List button text style
  /// that is different than its menu items.
  ///
  /// ```dart
  /// List<String> options = <String>['One', 'Two', 'Free', 'Four'];
  /// String ListValue = 'One';
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     alignment: Alignment.center,
  ///     color: Colors.blue,
  ///     child: ListButton<String>(
  ///       value: ListValue,
  ///       onChanged: (String newValue) {
  ///         setState(() {
  ///           ListValue = newValue;
  ///         });
  ///       },
  ///       style: TextStyle(color: Colors.blue),
  ///       selectedItemBuilder: (BuildContext context) {
  ///         return options.map((String value) {
  ///           return Text(
  ///             ListValue,
  ///             style: TextStyle(color: Colors.white),
  ///           );
  ///         }).toList();
  ///       },
  ///       items: options.map<ListMenuItem<String>>((String value) {
  ///         return ListMenuItem<String>(
  ///           value: value,
  ///           child: Text(value),
  ///         );
  ///       }).toList(),
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// Defaults to the [TextTheme.subtitle1] value of the current
  /// [ThemeData.textTheme] of the current [Theme].
  final TextStyle? style;

  /// The widget to use for the drop-down button's icon.
  ///
  /// Defaults to an [Icon] with the [Icons.arrow_drop_down] glyph.
  final Widget? icon;

  /// The color of any [Icon] descendant of [icon] if this button is disabled,
  /// i.e. if [onChanged] is null.
  ///
  /// Defaults to [Colors.grey.shade400] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white10] when it is [Brightness.dark]
  final Color? iconDisabledColor;

  /// The color of any [Icon] descendant of [icon] if this button is enabled,
  /// i.e. if [onChanged] is defined.
  ///
  /// Defaults to [Colors.grey.shade700] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white70] when it is [Brightness.dark]
  final Color? iconEnabledColor;

  /// The size to use for the drop-down button's down arrow icon button.
  ///
  /// Defaults to 24.0.
  final double iconSize;

  /// Reduce the button's height.
  ///
  /// By default this button's height is the same as its menu items' heights.
  /// If isDense is true, the button's height is reduced by about half. This
  /// can be useful when the button is embedded in a container that adds
  /// its own decorations, like [InputDecorator].
  final bool isDense;

  /// Set the List's inner contents to horizontally fill its parent.
  ///
  /// By default this button's inner width is the minimum size of its contents.
  /// If [isExpanded] is true, the inner width is expanded to fill its
  /// surrounding container.
  final bool isExpanded;

  /// If null, then the menu item heights will vary according to each menu item's
  /// intrinsic height.
  ///
  /// The default value is [kMinInteractiveDimension], which is also the minimum
  /// height for menu items.
  ///
  /// If this value is null and there isn't enough vertical room for the menu,
  /// then the menu's initial scroll offset may not align the selected item with
  /// the List button. That's because, in this case, the initial scroll
  /// offset is computed as if all of the menu item heights were
  /// [kMinInteractiveDimension].
  final double itemHeight;

  /// The color for the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The background color of the List.
  ///
  /// If it is not provided, the theme's [ThemeData.canvasColor] will be used
  /// instead.
  final Color? ListColor;

  final bool allowClear;
  final Widget deleteIcon;

  /// The maximum height of the menu.
  ///
  /// The maximum height of the menu must be at least one row shorter than
  /// the height of the app's view. This ensures that a tappable area
  /// outside of the simple menu is present so the user can dismiss the menu.
  ///
  /// If this property is set above the maximum allowable height threshold
  /// mentioned above, then the menu defaults to being padded at the top
  /// and bottom of the menu by at one menu item's height.
  final double? menuMaxHeight;

  final bool shouldRequestFocus;

  var addIcon;

  /// Creates field for List button
  FormBuilderList({
    Key? key,
    //From Super
    required String name,
    FormFieldValidator<List<String>>? validator,
    List<String>? initialValue,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<List<String>?>? onChanged,
    ValueTransformer<List<String>?>? valueTransformer,
    bool enabled = true,
    FormFieldSetter<List<String>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    VoidCallback? onReset,
    FocusNode? focusNode,
    // required this.items,
    this.isExpanded = true,
    this.isDense = true,
    this.elevation = 8,
    this.iconSize = 24.0,
    this.hint,
    this.style,
    this.disabledHint,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.allowClear = false,
    this.deleteIcon = const Icon(Icons.delete),
    this.addIcon = const Icon(Icons.add),
    this.onTap,
    this.autofocus = false,
    this.shouldRequestFocus = false,
    this.ListColor,
    this.focusColor,
    this.itemHeight = kMinInteractiveDimension,
    this.menuMaxHeight,
  }) : /*: assert(allowClear == true || clearIcon != null)*/ super(
          key: key,
          initialValue: initialValue,
          name: name,
          validator: validator,
          valueTransformer: valueTransformer,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          enabled: enabled,
          onReset: onReset,
          decoration: decoration,
          focusNode: focusNode,
          builder: (FormFieldState<List<String>?> field) {
            final state = field as _FormBuilderListState;

            return ListView.builder(
              itemCount: state.value?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.value![index]),
                  trailing: IconButton(
                    icon: deleteIcon,
                    onPressed: () {
                      state.value?.removeAt(index);
                      state.didChange(state.value);
                    },
                  ),
                );
              },
            );
          },
        );

  @override
  _FormBuilderListState createState() => _FormBuilderListState();
}

class _FormBuilderListState extends FormBuilderFieldState<FormBuilderList, List<String>> {
  @override
  void didChange(List<String>? value) {
    super.didChange(value);
  }
}
