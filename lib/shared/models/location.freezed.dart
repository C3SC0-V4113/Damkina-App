// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Location {

 String get id; String get userId; String get name; double get latitude; double get longitude; double get altitude; String get koppenClassification; String get climateSummary; String get seasonalitySummary; String get currentSeason; DateTime get createdAt;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.koppenClassification, koppenClassification) || other.koppenClassification == koppenClassification)&&(identical(other.climateSummary, climateSummary) || other.climateSummary == climateSummary)&&(identical(other.seasonalitySummary, seasonalitySummary) || other.seasonalitySummary == seasonalitySummary)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,latitude,longitude,altitude,koppenClassification,climateSummary,seasonalitySummary,currentSeason,createdAt);

@override
String toString() {
  return 'Location(id: $id, userId: $userId, name: $name, latitude: $latitude, longitude: $longitude, altitude: $altitude, koppenClassification: $koppenClassification, climateSummary: $climateSummary, seasonalitySummary: $seasonalitySummary, currentSeason: $currentSeason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, double latitude, double longitude, double altitude, String koppenClassification, String climateSummary, String seasonalitySummary, String currentSeason, DateTime createdAt
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? koppenClassification = null,Object? climateSummary = null,Object? seasonalitySummary = null,Object? currentSeason = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,koppenClassification: null == koppenClassification ? _self.koppenClassification : koppenClassification // ignore: cast_nullable_to_non_nullable
as String,climateSummary: null == climateSummary ? _self.climateSummary : climateSummary // ignore: cast_nullable_to_non_nullable
as String,seasonalitySummary: null == seasonalitySummary ? _self.seasonalitySummary : seasonalitySummary // ignore: cast_nullable_to_non_nullable
as String,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  double latitude,  double longitude,  double altitude,  String koppenClassification,  String climateSummary,  String seasonalitySummary,  String currentSeason,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.latitude,_that.longitude,_that.altitude,_that.koppenClassification,_that.climateSummary,_that.seasonalitySummary,_that.currentSeason,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  double latitude,  double longitude,  double altitude,  String koppenClassification,  String climateSummary,  String seasonalitySummary,  String currentSeason,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.id,_that.userId,_that.name,_that.latitude,_that.longitude,_that.altitude,_that.koppenClassification,_that.climateSummary,_that.seasonalitySummary,_that.currentSeason,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  double latitude,  double longitude,  double altitude,  String koppenClassification,  String climateSummary,  String seasonalitySummary,  String currentSeason,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.latitude,_that.longitude,_that.altitude,_that.koppenClassification,_that.climateSummary,_that.seasonalitySummary,_that.currentSeason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.id, required this.userId, required this.name, required this.latitude, required this.longitude, required this.altitude, required this.koppenClassification, required this.climateSummary, required this.seasonalitySummary, required this.currentSeason, required this.createdAt});
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double altitude;
@override final  String koppenClassification;
@override final  String climateSummary;
@override final  String seasonalitySummary;
@override final  String currentSeason;
@override final  DateTime createdAt;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.koppenClassification, koppenClassification) || other.koppenClassification == koppenClassification)&&(identical(other.climateSummary, climateSummary) || other.climateSummary == climateSummary)&&(identical(other.seasonalitySummary, seasonalitySummary) || other.seasonalitySummary == seasonalitySummary)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,latitude,longitude,altitude,koppenClassification,climateSummary,seasonalitySummary,currentSeason,createdAt);

@override
String toString() {
  return 'Location(id: $id, userId: $userId, name: $name, latitude: $latitude, longitude: $longitude, altitude: $altitude, koppenClassification: $koppenClassification, climateSummary: $climateSummary, seasonalitySummary: $seasonalitySummary, currentSeason: $currentSeason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, double latitude, double longitude, double altitude, String koppenClassification, String climateSummary, String seasonalitySummary, String currentSeason, DateTime createdAt
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? koppenClassification = null,Object? climateSummary = null,Object? seasonalitySummary = null,Object? currentSeason = null,Object? createdAt = null,}) {
  return _then(_Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,koppenClassification: null == koppenClassification ? _self.koppenClassification : koppenClassification // ignore: cast_nullable_to_non_nullable
as String,climateSummary: null == climateSummary ? _self.climateSummary : climateSummary // ignore: cast_nullable_to_non_nullable
as String,seasonalitySummary: null == seasonalitySummary ? _self.seasonalitySummary : seasonalitySummary // ignore: cast_nullable_to_non_nullable
as String,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
