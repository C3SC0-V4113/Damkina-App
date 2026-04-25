import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/features/locations/domain/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:permission_handler/permission_handler.dart';

class MapboxLocationPickerScreen extends StatefulWidget {
  const MapboxLocationPickerScreen({
    required this.hasMapboxToken,
    this.initialSelection,
    super.key,
  });

  final bool hasMapboxToken;
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

  mapbox.MapboxMap? _mapboxMap;
  late MapSelection _currentSelection;
  bool _isRequestingCurrentLocation = false;
  String? _requestError;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.initialSelection ?? _defaultSelection;
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
            },
            onCameraChangeListener: (event) {
              final coordinates = event.cameraState.center.coordinates;
              if (!mounted) {
                return;
              }
              setState(() {
                _currentSelection = MapSelection(
                  latitude: coordinates.lat.toDouble(),
                  longitude: coordinates.lng.toDouble(),
                  altitude: coordinates.alt?.toDouble(),
                );
              });
            },
          ),
          const Center(
            child: IgnorePointer(
              child: Icon(
                Icons.location_on,
                size: 44,
                color: AppColors.forest,
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            top: AppSpacing.md,
            child: FloatingActionButton.small(
              onPressed: _isRequestingCurrentLocation
                  ? null
                  : _moveToCurrentLocation,
              child: _isRequestingCurrentLocation
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Lat ${_currentSelection.latitude.toStringAsFixed(5)} '
                      '- Lng ${_currentSelection.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_requestError != null) ...[
                      const SizedBox(height: AppSpacing.xs),
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
          _requestError = 'Location permission is required to center on your '
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
