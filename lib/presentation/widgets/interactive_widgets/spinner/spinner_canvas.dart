import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bento_clone/presentation/extensions/colour_extension.dart';
import 'package:bento_clone/presentation/utils/app_styles.dart';
import 'spinner_painter.dart';

class SpinnerCanvas extends StatefulWidget {
  final List<String> items;
  final String? title;
  final String? backgroundColour;

  const SpinnerCanvas({
    super.key,
    required this.items,
    this.title,
    this.backgroundColour,
  });

  @override
  State<SpinnerCanvas> createState() => _SpinnerCanvasState();
}

class _SpinnerCanvasState extends State<SpinnerCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _currentAngle = 0;
  String? _result;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _spinning = false;
          _result = _calculateWinner();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_spinning) return;
    final random = Random();
    final spins = 4 + random.nextInt(6); // 4–9 full rotations
    final offset = random.nextDouble() * (2 * pi);
    final endAngle = _currentAngle + (spins * 2 * pi) + offset;

    _animation = Tween<double>(begin: _currentAngle, end: endAngle).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    setState(() {
      _spinning = true;
      _result = null;
    });
    _controller.reset();
    _controller.forward();
  }

  String _calculateWinner() {
    final count = widget.items.length;
    final sweep = (2 * pi) / count;

    // Strip full rotations to get net position within one revolution.
    // Mirrors the original: _spinnerAnimation.value % radiansFor360.
    final netAngle = _currentAngle % (2 * pi);

    // Rotate each segment by netAngle (mirrors _incrementEachSegmentWithNewSpinValue)
    // then check which one contains the fixed pointer at 2π ≡ 0 (the top).
    // Mirrors _findWinningSegment checking against radiansFor360.
    const double pointer = 2 * pi;

    for (var i = 0; i < count; i++) {
      final double start = ((sweep * i) + netAngle) % (2 * pi);
      final double end = ((sweep * (i + 1)) + netAngle) % (2 * pi);

      // If start < end the segment doesn't wrap — simple bounds check.
      // If start > end the segment wraps around 0/2π — same logic as original.
      final bool wins = start < end
          ? start <= pointer && pointer <= end
          : start <= pointer || pointer <= end;

      if (wins) return widget.items[i];
    }

    // Fallback — should never be reached with a valid segment list
    return widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        // Reserve space for title, result label and button
        final reservedVertical = 72.0 + (widget.title != null ? 24.0 : 0);
        final wheelDiameter = (size.shortestSide - reservedVertical).clamp(
          60.0,
          size.shortestSide,
        );
        final pointerSize = (wheelDiameter * 0.08).clamp(8.0, 16.0);

        // Derive text colour from the tile's background colour, matching the
        // pattern used by TextTileRenderer. Falls back to onSurface when no
        // colour is configured (transparent tile).
        final Color textColour = widget.backgroundColour != null
            ? widget.backgroundColour!.toColour().contrastingTextColour
            : Theme.of(context).colorScheme.onSurface;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: ResponsiveText.labelLarge(context)
                    ?.copyWith(fontWeight: FontWeight.bold, color: textColour),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
            ],
            // Pointer
            Icon(
              Icons.arrow_drop_down_rounded,
              size: pointerSize * 2,
              color: textColour,
            ),
            // Wheel
            SizedBox(
              width: wheelDiameter,
              height: wheelDiameter,
              child: GestureDetector(
                onTap: _spin,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: SpinnerPainter(
                      items: widget.items,
                      currentAngle: _currentAngle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Result or spin prompt
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _result != null
                  ? Text(
                      _result!,
                      key: ValueKey(_result),
                      style: ResponsiveText.labelMedium(context)?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColour,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      _spinning ? '' : 'Tap to Spin',
                      key: const ValueKey('prompt'),
                      style: ResponsiveText.labelMedium(context)?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColour,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        );
      },
    );
  }
}
