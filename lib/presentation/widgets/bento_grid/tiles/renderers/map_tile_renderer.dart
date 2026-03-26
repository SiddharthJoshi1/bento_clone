import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';

/// Renders a live OpenStreetMap tile centred on [TileConfig.latitude] /
/// [TileConfig.longitude]. Falls back to a placeholder when coordinates are
/// absent or the network is unavailable.
class MapTileRenderer extends StatelessWidget {
  final TileConfig config;

  const MapTileRenderer({super.key, required this.config});

  /// Whether this tile has usable coordinates.
  bool get _hasCoords =>
      config.latitude != null && config.longitude != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasCoords) return _buildPlaceholder(context);

    final centre = LatLng(config.latitude!, config.longitude!);

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: centre,
            initialZoom: MapConstants.defaultZoom,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag)
          ),
          children: [
            TileLayer(
              urlTemplate: MapConstants.tileUrlTemplate,
              userAgentPackageName: MapConstants.userAgentPackageName,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: centre,
                  width: 60,
                  height: 60,
                  child: const _PulsingLocationDot(),
                ),
              ],
            ),
          ],
        ),
        if (config.title != null && config.title!.isNotEmpty)
          Positioned(
            bottom: AppInsets.s,
            left: AppInsets.s,
            right: AppInsets.s,
            child: _buildLabel(context),
          ),
      ],
    );
  }

  /// Pill label shown over the map with the tile's title.
  Widget _buildLabel(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppInsets.s,
            vertical: AppInsets.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppInsets.s),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            config.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ResponsiveText.caption(context)?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// Shown when coordinates are missing — keeps the tile non-empty in dev.
  Widget _buildPlaceholder(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: AppColors.mapBackground),
        const Center(
          child: Icon(
            Icons.location_on_outlined,
            color: AppColors.mapPin,
            size: AppIconSizes.xl,
          ),
        ),
        if (config.title != null && config.title!.isNotEmpty)
          Positioned(
            bottom: AppInsets.s,
            left: AppInsets.s,
            right: AppInsets.s,
            child: _buildLabel(context),
          ),
      ],
    );
  }
}

/// Apple-style pulsing blue location dot.
///
/// Two staggered rings scale outward and fade, with a white-bordered
/// blue dot in the centre — matching the iOS Maps / Find My aesthetic.
class _PulsingLocationDot extends StatefulWidget {
  const _PulsingLocationDot();

  @override
  State<_PulsingLocationDot> createState() => _PulsingLocationDotState();
}

class _PulsingLocationDotState extends State<_PulsingLocationDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Ring 1 — leads
  late final Animation<double> _ring1Scale;
  late final Animation<double> _ring1Opacity;

  // Ring 2 — follows with a 0.4s delay
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Opacity;

  static const _dotColour = Color(0xFF2A7FE8);
  static const _ringColour = Color(0xFF378ADD);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Ring 1: full cycle
    _ring1Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring1Opacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    // Ring 2: starts at 40% through the cycle
    _ring2Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring2Opacity = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 2 (behind ring 1)
              _buildRing(_ring2Scale.value, _ring2Opacity.value),
              // Ring 1
              _buildRing(_ring1Scale.value, _ring1Opacity.value),
              // White border
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              // Blue dot
              Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: _dotColour,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing(double scale, double opacity) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: 60 * scale,
        height: 60 * scale,
        decoration: BoxDecoration(
          color: _ringColour,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
