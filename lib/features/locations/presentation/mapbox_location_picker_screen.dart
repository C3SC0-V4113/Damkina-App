import 'dart:async';

import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:permission_handler/permission_handler.dart';

typedef ReverseGeocodeResolver =
    Future<String?> Function({
      required double latitude,
      required double longitude,
    });
typedef AltitudeResolver =
    Future<double?> Function({
      required double latitude,
      required double longitude,
    });

class MapboxLocationPickerScreen extends StatefulWidget {
  const MapboxLocationPickerScreen({
    required this.hasMapboxToken,
    this.resolveAddress,
    this.resolveAltitude,
    this.initialSelection,
    super.key,
  });

  final bool hasMapboxToken;
  final ReverseGeocodeResolver? resolveAddress;
  final AltitudeResolver? resolveAltitude;
  final MapSelection? initialSelection;

  @override
  State<MapboxLocationPickerScreen> createState() =>
      _MapboxLocationPickerScreenState();
}

class _MapboxLocationPickerScreenState
    extends State<MapboxLocationPickerScreen> {
  static const _defaultSelection = MapSelection(
    latitude: 13.6929,
    longitude: -89.2182,
    altitude: 658,
  );
  static const _zoomStep = 1.0;
  static const _minZoom = 2.0;
  static const _maxZoom = 20.0;

  mapbox.MapboxMap? _mapboxMap;
  late MapSelection _currentSelection;
  bool _isRequestingCurrentLocation = false;
  bool _isResolvingAddress = false;
  bool _isResolvingAltitude = false;
  bool _addressError = false;
  bool _altitudeError = false;
  String? _requestError;
  String? _resolvedAddress;
  Timer? _addressDebounce;
  Timer? _altitudeDebounce;
  int _addressRequestId = 0;
  int _altitudeRequestId = 0;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.initialSelection ?? _defaultSelection;
  }

  @override
  void dispose() {
    _addressDebounce?.cancel();
    _altitudeDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasMapboxToken) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select location')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Mapbox token is missing.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Run the app with --dart-define MAPBOX_ACCESS_TOKEN=... '
                  'to enable location picking.',
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: Stack(
        children: [
          mapbox.MapWidget(
            key: const ValueKey('mapbox-location-picker'),
            styleUri: mapbox.MapboxStyles.OUTDOORS,
            cameraOptions: mapbox.CameraOptions(
              center: _pointFromSelection(_currentSelection),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapboxMap = controller;
              _scheduleAddressResolution(_currentSelection);
              _scheduleAltitudeResolution(_currentSelection);
            },
            onCameraChangeListener: (event) {
              final coordinates = event.cameraState.center.coordinates;
              final nextSelection = MapSelection(
                latitude: coordinates.lat.toDouble(),
                longitude: coordinates.lng.toDouble(),
              );
              if (!mounted) {
                return;
              }
              setState(() {
                _currentSelection = nextSelection;
              });
              _scheduleAddressResolution(nextSelection);
              _scheduleAltitudeResolution(nextSelection);
            },
          ),
          Center(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.forest.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: const Icon(
                  Icons.location_on,
                  size: 44,
                  color: AppColors.forest,
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            child: SafeArea(
              bottom: false,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricItem(
                          label: 'Coordinates',
                          value: _formatCoordinates(_currentSelection),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                        child: VerticalDivider(color: AppColors.line),
                      ),
                      Expanded(
                        child: _MetricItem(
                          label: 'Altitude',
                          value: _formatAltitude(
                            altitude: _currentSelection.altitude,
                            isResolvingAltitude: _isResolvingAltitude,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.md,
                  bottom: 64,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControlButton(
                      icon: Icons.add,
                      onPressed: () => _changeZoom(_zoomStep),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MapControlButton(
                      icon: Icons.remove,
                      onPressed: () => _changeZoom(-_zoomStep),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MapControlButton(
                      icon: Icons.my_location,
                      onPressed: _isRequestingCurrentLocation
                          ? null
                          : _moveToCurrentLocation,
                      child: _isRequestingCurrentLocation
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: SafeArea(
              top: false,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Use this location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.mutedInk,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _buildAddressInfo(),
                              style: const TextStyle(color: AppColors.mutedInk),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (_requestError != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _requestError!,
                          style: const TextStyle(color: AppColors.danger),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_currentSelection),
                        child: const Text('Use this location'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _moveToCurrentLocation() async {
    setState(() {
      _isRequestingCurrentLocation = true;
      _requestError = null;
    });

    try {
      final permission = await Permission.locationWhenInUse.request();
      if (!permission.isGranted) {
        setState(() {
          _requestError =
              'Location permission is required to center on your '
              'current place.';
        });
        return;
      }

      final position = await geolocator.Geolocator.getCurrentPosition();
      final selection = MapSelection(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude.isFinite ? position.altitude : null,
      );

      setState(() {
        _currentSelection = selection;
      });
      _scheduleAddressResolution(selection);
      _scheduleAltitudeResolution(selection);

      await _mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: _pointFromSelection(selection),
          zoom: 16,
        ),
        mapbox.MapAnimationOptions(
          duration: 1200,
          startDelay: 0,
        ),
      );
    } on Exception {
      setState(() {
        _requestError =
            'Unable to read current location. Move the map manually.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingCurrentLocation = false;
        });
      }
    }
  }

  Future<void> _changeZoom(double delta) async {
    final map = _mapboxMap;
    if (map == null) {
      return;
    }

    try {
      final state = await map.getCameraState();
      final nextZoom = (state.zoom + delta).clamp(_minZoom, _maxZoom);
      await map.easeTo(
        mapbox.CameraOptions(zoom: nextZoom),
        mapbox.MapAnimationOptions(
          duration: 250,
          startDelay: 0,
        ),
      );
    } on Exception {
      // No-op: zoom controls should not block location picking.
    }
  }

  void _scheduleAddressResolution(MapSelection selection) {
    final resolver = widget.resolveAddress;
    _addressDebounce?.cancel();
    if (resolver == null) {
      if (mounted && !_addressError) {
        setState(() {
          _isResolvingAddress = false;
          _resolvedAddress = null;
          _addressError = true;
        });
      }
      return;
    }

    _addressDebounce = Timer(const Duration(milliseconds: 700), () {
      unawaited(_resolveAddressForSelection(selection, resolver));
    });
  }

  void _scheduleAltitudeResolution(MapSelection selection) {
    final resolver = widget.resolveAltitude;
    _altitudeDebounce?.cancel();
    if (resolver == null) {
      if (mounted) {
        setState(() {
          _isResolvingAltitude = false;
          _altitudeError = true;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isResolvingAltitude = true;
        _altitudeError = false;
      });
    }

    _altitudeDebounce = Timer(const Duration(milliseconds: 700), () {
      unawaited(_resolveAltitudeForSelection(selection, resolver));
    });
  }

  Future<void> _resolveAddressForSelection(
    MapSelection selection,
    ReverseGeocodeResolver resolver,
  ) async {
    final requestId = ++_addressRequestId;
    if (mounted) {
      setState(() {
        _isResolvingAddress = true;
      });
    }

    try {
      final address = await resolver(
        latitude: selection.latitude,
        longitude: selection.longitude,
      );
      if (!mounted || requestId != _addressRequestId) {
        return;
      }

      setState(() {
        _isResolvingAddress = false;
        _resolvedAddress = address;
        _addressError = address == null;
      });
    } on Exception {
      if (!mounted || requestId != _addressRequestId) {
        return;
      }
      setState(() {
        _isResolvingAddress = false;
        _resolvedAddress = null;
        _addressError = true;
      });
    }
  }

  Future<void> _resolveAltitudeForSelection(
    MapSelection selection,
    AltitudeResolver resolver,
  ) async {
    final requestId = ++_altitudeRequestId;

    try {
      final altitude = await resolver(
        latitude: selection.latitude,
        longitude: selection.longitude,
      );
      if (!mounted || requestId != _altitudeRequestId) {
        return;
      }

      setState(() {
        _isResolvingAltitude = false;
        _altitudeError = altitude == null;
        _currentSelection = MapSelection(
          latitude: selection.latitude,
          longitude: selection.longitude,
          altitude: altitude,
        );
      });
    } on Exception {
      if (!mounted || requestId != _altitudeRequestId) {
        return;
      }
      setState(() {
        _isResolvingAltitude = false;
        _altitudeError = true;
        _currentSelection = MapSelection(
          latitude: selection.latitude,
          longitude: selection.longitude,
        );
      });
    }
  }

  String _buildAddressInfo() {
    if (_isResolvingAddress) {
      return 'Resolving address...';
    }

    final resolvedAddress = _resolvedAddress;
    if (resolvedAddress != null) {
      return 'This location will be saved with climate information and '
          'address: $resolvedAddress';
    }

    if (_addressError) {
      return 'This location will be saved with climate information. '
          'Address is not available yet.';
    }

    return 'This location will be saved with climate information and address.';
  }

  String _formatCoordinates(MapSelection selection) {
    final latitudeDirection = selection.latitude >= 0 ? 'N' : 'S';
    final longitudeDirection = selection.longitude >= 0 ? 'E' : 'W';
    final latitude = selection.latitude.abs().toStringAsFixed(4);
    final longitude = selection.longitude.abs().toStringAsFixed(4);
    return '$latitude\u00B0 $latitudeDirection, $longitude\u00B0 '
        '$longitudeDirection';
  }

  String _formatAltitude({
    required double? altitude,
    required bool isResolvingAltitude,
  }) {
    if (isResolvingAltitude) {
      return '...';
    }
    if (_altitudeError || altitude == null || !altitude.isFinite) {
      return '--';
    }
    return '${altitude.round()} msnm';
  }

  mapbox.Point _pointFromSelection(MapSelection selection) {
    return mapbox.Point(
      coordinates: mapbox.Position(
        selection.longitude,
        selection.latitude,
        selection.altitude,
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final String value;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.mutedInk,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    this.child,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: FloatingActionButton.small(
        heroTag: null,
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.forest,
        child: child ?? Icon(icon),
      ),
    );
  }
}
