import 'package:flutter/material.dart';
import '../../../../presentation/widgets/interactive_widgets/interactive_widget.dart';
import 'spinner_canvas.dart';

/// Interactive spinning wheel widget.
///
/// widget_config keys:
///   items  — required, List[String], the segments to display
///   title  — optional, String, label shown above the wheel
///
/// Example content.json entry:
/// ```json
/// {
///   "type": "widgets",
///   "tile_size": "half_tower",
///   "title": "Spin the wheel",
///   "widget_id": "spinner_v1",
///   "widget_config": {
///     "title": "What to build next?",
///     "items": ["Side project", "Blog post", "Open source", "Take a break", "New widget", "Refactor"]
///   }
/// }
/// ```
class SpinnerWidget extends InteractiveWidget {
  const SpinnerWidget();

  @override
  String get widgetId => 'spinner_v1';

  @override
  String get displayName => 'Spin the Wheel';

  @override
  String get description => 'A configurable spinning wheel decision randomiser.';

  @override
  List<String> get tags => ['interactive', 'fun', 'random'];

  @override
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour}) {
    final rawItems = config['items'];
    final items = rawItems is List
        ? rawItems.map((e) => e.toString()).toList()
        : <String>['Option 1', 'Option 2', 'Option 3'];

    final title = config['title'] as String?;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SpinnerCanvas(
        items: items,
        title: title,
        backgroundColour: colour,
      ),
    );
  }
}
