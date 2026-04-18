import 'interactive_widget.dart';
import 'spinner/spinner_widget.dart';

/// Static registry mapping [InteractiveWidget.widgetId] → factory function.
///
/// To add a new interactive widget:
/// 1. Create `lib/presentation/widgets/interactive_widgets/your_widget/your_widget.dart`
///    implementing [InteractiveWidget].
/// 2. Import it here and add one line to [_widgets].
/// That's it — [SmartBentoTile] resolves everything else automatically.
class WidgetRegistry {
  WidgetRegistry._();

  static final Map<String, InteractiveWidget Function()> _widgets = {
    'spinner_v1': SpinnerWidget.new,
  };

  /// Returns an [InteractiveWidget] instance for [widgetId], or null if not found.
  static InteractiveWidget? getWidget(String widgetId) =>
      _widgets[widgetId]?.call();

  /// All registered widget IDs — useful for dev tooling / debugging.
  static List<String> get allIds => _widgets.keys.toList();
}
