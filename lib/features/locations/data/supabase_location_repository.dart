import 'dart:convert';

import 'package:damkina_app/features/locations/domain/location_repository.dart';
import 'package:damkina_app/shared/models/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseLocationRepository implements LocationRepository {
  SupabaseLocationRepository({required SupabaseClient client})
    : _client = client;

  final SupabaseClient _client;
  String? _activeLocationId;

  @override
  Future<void> deleteLocation(String id) async {
    await _client.from('locations').delete().eq('id', id);
    if (_activeLocationId == id) {
      _activeLocationId = null;
    }
  }

  @override
  Future<Location?> getActiveLocation() async {
    if (_activeLocationId != null) {
      final location = await getLocationById(_activeLocationId!);
      if (location != null) {
        return location;
      }
      _activeLocationId = null;
    }

    final locations = await listLocations();
    if (locations.isEmpty) {
      return null;
    }

    final latest = locations.reduce(
      (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
    );
    _activeLocationId = latest.id;
    return latest;
  }

  @override
  Future<Location?> getLocationById(String id) async {
    final data = await _client
        .from('locations')
        .select(
          'id, user_id, name, latitude, longitude, altitude, '
          'koppen_classification, climate_summary, seasonality_summary, '
          'created_at',
        )
        .eq('id', id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return _mapLocation(data);
  }

  @override
  Future<bool> hasAnyLocationForUser(String userId) async {
    final data = await _client
        .from('locations')
        .select('id')
        .eq('user_id', userId)
        .limit(1)
        .maybeSingle();
    return data != null;
  }

  @override
  Future<List<Location>> listLocations() async {
    final rows = await _client
        .from('locations')
        .select(
          'id, user_id, name, latitude, longitude, altitude, '
          'koppen_classification, climate_summary, seasonality_summary, '
          'created_at',
        )
        .order('created_at', ascending: false);

    return rows.map(_mapLocation).toList(growable: false);
  }

  @override
  Future<Location> saveLocation(Location location) async {
    final payload = <String, dynamic>{
      'user_id': location.userId,
      'name': location.name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'altitude': location.altitude,
      'koppen_classification': location.koppenClassification,
      'climate_summary': _encodeSummary(location.climateSummary),
      'seasonality_summary': _encodeSeasonality(
        location.seasonalitySummary,
        location.currentSeason,
      ),
    };

    final hasUuidId = _isUuid(location.id);
    if (hasUuidId) {
      payload['id'] = location.id;
    }

    final saved = await _client
        .from('locations')
        .upsert(payload)
        .select(
          'id, user_id, name, latitude, longitude, altitude, '
          'koppen_classification, climate_summary, seasonality_summary, '
          'created_at',
        )
        .single();

    return _mapLocation(saved);
  }

  @override
  Future<void> setActiveLocation(String id) async {
    final exists = await getLocationById(id);
    if (exists != null) {
      _activeLocationId = id;
    }
  }

  Map<String, dynamic> _encodeSummary(String summary) {
    return {'summary': summary};
  }

  Map<String, dynamic> _encodeSeasonality(
    String summary,
    String currentSeason,
  ) {
    return {
      'summary': summary,
      'current_season': currentSeason,
    };
  }

  bool _isUuid(String value) {
    final uuidRegex = RegExp(
      '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}'
      '-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}',
    );
    return value.length == 36 && uuidRegex.hasMatch(value);
  }

  Location _mapLocation(Map<String, dynamic> row) {
    final climate = row['climate_summary'];
    final seasonality = row['seasonality_summary'];

    return Location(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      name: row['name'] as String,
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      altitude: _toDouble(row['altitude']),
      koppenClassification:
          (row['koppen_classification'] as String?)?.trim().isNotEmpty == true
          ? row['koppen_classification'] as String
          : 'pending',
      climateSummary: _jsonSummaryOrFallback(
        climate,
        fallback: 'Environmental profile pending enrichment.',
      ),
      seasonalitySummary: _jsonSummaryOrFallback(
        seasonality,
        fallback: 'Seasonality data pending enrichment.',
      ),
      currentSeason: _jsonCurrentSeasonOrFallback(
        seasonality,
        fallback: 'Pending',
      ),
      createdAt:
          DateTime.tryParse(row['created_at'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _jsonSummaryOrFallback(
    Object? value, {
    required String fallback,
  }) {
    if (value is Map<String, dynamic>) {
      final summary = value['summary']?.toString().trim();
      if (summary != null && summary.isNotEmpty) {
        return summary;
      }
      return jsonEncode(value);
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return fallback;
  }

  String _jsonCurrentSeasonOrFallback(
    Object? value, {
    required String fallback,
  }) {
    if (value is Map<String, dynamic>) {
      final season = value['current_season']?.toString().trim();
      if (season != null && season.isNotEmpty) {
        return season;
      }
    }
    return fallback;
  }
}
