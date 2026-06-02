import 'package:flutter/material.dart';

/// A card-style selector that opens a bottom-sheet list picker.
///
/// Use in place of [DropdownButtonFormField] throughout the app to match
/// the warm-modern aesthetic.
class AppOptionPicker<T> extends StatelessWidget {
  const AppOptionPicker({
    required this.options,
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.icon,
    required this.itemLabel,
    this.sheetTitle,
    this.itemIcon,
    this.itemIconColor,
    super.key,
  });

  /// The full list of selectable options.
  final List<T> options;

  /// The currently selected value, or null if nothing is selected yet.
  final T? value;

  /// Called when the user selects an option.
  final void Function(T) onChanged;

  /// Small caption label shown above the selected value in the trigger card.
  final String labelText;

  /// Leading icon shown in the trigger card.
  final IconData icon;

  /// Returns the display label for a given option.
  final String Function(T) itemLabel;

  /// Optional title override for the bottom sheet (defaults to [labelText]).
  final String? sheetTitle;

  /// Optional per-item icon override (falls back to [icon]).
  final IconData Function(T)? itemIcon;

  /// Optional per-item icon color. May return null to use the default color.
  final Color? Function(T)? itemIconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = value;
    final selectedLabel = selected != null ? itemLabel(selected) : null;

    final Color leadingColor;
    if (selected != null && itemIconColor != null) {
      leadingColor = itemIconColor!(selected) ?? colorScheme.outline;
    } else {
      leadingColor = colorScheme.outline;
    }

    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: leadingColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.outline,
                      letterSpacing: 0.4,
                    ),
                  ),
                  if (selectedLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      selectedLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => _OptionPickerSheet<T>(
        title: sheetTitle ?? labelText,
        options: options,
        selectedValue: value,
        defaultIcon: icon,
        itemLabel: itemLabel,
        itemIcon: itemIcon,
        itemIconColor: itemIconColor,
      ),
    );
    if (result != null) onChanged(result);
  }
}

// ---------------------------------------------------------------------------
// Bottom-sheet content
// ---------------------------------------------------------------------------

class _OptionPickerSheet<T> extends StatelessWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.defaultIcon,
    required this.itemLabel,
    this.itemIcon,
    this.itemIconColor,
  });

  final String title;
  final List<T> options;
  final T? selectedValue;
  final IconData defaultIcon;
  final String Function(T) itemLabel;
  final IconData Function(T)? itemIcon;
  final Color? Function(T)? itemIconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle.
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Sheet title.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            const Divider(height: 1),

            // Scrollable list.
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: options.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 56),
                itemBuilder: (_, i) {
                  final option = options[i];
                  final isSelected = option == selectedValue;
                  final icon = itemIcon?.call(option) ?? defaultIcon;
                  final color =
                      itemIconColor?.call(option) ?? colorScheme.outline;
                  return InkWell(
                    onTap: () => Navigator.of(ctx).pop(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(icon, size: 20, color: color),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              itemLabel(option),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
