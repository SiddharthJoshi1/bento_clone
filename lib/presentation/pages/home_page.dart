import 'package:bento_clone/presentation/utils/colour_extension.dart';
import 'package:bento_clone/presentation/utils/sizing_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/repos/link_repo.dart';
import '../utils/icon_mapping.dart';
import '../widgets/ultra_background.dart';

class HomePage extends StatelessWidget {
  final Widget profileWidget;
  final Widget tileSectionWidget;
  const HomePage({
    super.key,
    required this.profileWidget,
    required this.tileSectionWidget,
  });

  Widget buildHomePageWidget(BuildContext context) {
    //normal

    Widget widget = SizedBox.shrink();
    if (SizingUtils.isDesktop(context)) {
      widget = Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 4, child: profileWidget),
          Expanded(flex: 4, child: tileSectionWidget),
        ],
      );
    } else {
      widget = Align(
        alignment:
            Alignment.topCenter, // Stick to top, but centered horizontally
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: UltraBackground(child: tileSectionWidget),
          ),
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildHomePageWidget(context));
  }
}
