// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Crop {

 String get id; String get name; String get slug; String get shortDescription; int get minHarvestDays; int get maxHarvestDays; String get difficulty; String get soilType; double get soilPhMin; double get soilPhMax; int get sunHoursMin; int get sunHoursMax; String get sunlightIntensity; String get waterRequirement; double get idealTempMin; double get idealTempMax; int get altitudeMin; int get altitudeMax; List<String> get preferredKoppenTypes; List<String> get images;
/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CropCopyWith<Crop> get copyWith => _$CropCopyWithImpl<Crop>(this as Crop, _$identity);

  /// Serializes this Crop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Crop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.minHarvestDays, minHarvestDays) || other.minHarvestDays == minHarvestDays)&&(identical(other.maxHarvestDays, maxHarvestDays) || other.maxHarvestDays == maxHarvestDays)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.soilType, soilType) || other.soilType == soilType)&&(identical(other.soilPhMin, soilPhMin) || other.soilPhMin == soilPhMin)&&(identical(other.soilPhMax, soilPhMax) || other.soilPhMax == soilPhMax)&&(identical(other.sunHoursMin, sunHoursMin) || other.sunHoursMin == sunHoursMin)&&(identical(other.sunHoursMax, sunHoursMax) || other.sunHoursMax == sunHoursMax)&&(identical(other.sunlightIntensity, sunlightIntensity) || other.sunlightIntensity == sunlightIntensity)&&(identical(other.waterRequirement, waterRequirement) || other.waterRequirement == waterRequirement)&&(identical(other.idealTempMin, idealTempMin) || other.idealTempMin == idealTempMin)&&(identical(other.idealTempMax, idealTempMax) || other.idealTempMax == idealTempMax)&&(identical(other.altitudeMin, altitudeMin) || other.altitudeMin == altitudeMin)&&(identical(other.altitudeMax, altitudeMax) || other.altitudeMax == altitudeMax)&&const DeepCollectionEquality().equals(other.preferredKoppenTypes, preferredKoppenTypes)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,shortDescription,minHarvestDays,maxHarvestDays,difficulty,soilType,soilPhMin,soilPhMax,sunHoursMin,sunHoursMax,sunlightIntensity,waterRequirement,idealTempMin,idealTempMax,altitudeMin,altitudeMax,const DeepCollectionEquality().hash(preferredKoppenTypes),const DeepCollectionEquality().hash(images)]);

@override
String toString() {
  return 'Crop(id: $id, name: $name, slug: $slug, shortDescription: $shortDescription, minHarvestDays: $minHarvestDays, maxHarvestDays: $maxHarvestDays, difficulty: $difficulty, soilType: $soilType, soilPhMin: $soilPhMin, soilPhMax: $soilPhMax, sunHoursMin: $sunHoursMin, sunHoursMax: $sunHoursMax, sunlightIntensity: $sunlightIntensity, waterRequirement: $waterRequirement, idealTempMin: $idealTempMin, idealTempMax: $idealTempMax, altitudeMin: $altitudeMin, altitudeMax: $altitudeMax, preferredKoppenTypes: $preferredKoppenTypes, images: $images)';
}


}

/// @nodoc
abstract mixin class $CropCopyWith<$Res>  {
  factory $CropCopyWith(Crop value, $Res Function(Crop) _then) = _$CropCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String shortDescription, int minHarvestDays, int maxHarvestDays, String difficulty, String soilType, double soilPhMin, double soilPhMax, int sunHoursMin, int sunHoursMax, String sunlightIntensity, String waterRequirement, double idealTempMin, double idealTempMax, int altitudeMin, int altitudeMax, List<String> preferredKoppenTypes, List<String> images
});




}
/// @nodoc
class _$CropCopyWithImpl<$Res>
    implements $CropCopyWith<$Res> {
  _$CropCopyWithImpl(this._self, this._then);

  final Crop _self;
  final $Res Function(Crop) _then;

/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? shortDescription = null,Object? minHarvestDays = null,Object? maxHarvestDays = null,Object? difficulty = null,Object? soilType = null,Object? soilPhMin = null,Object? soilPhMax = null,Object? sunHoursMin = null,Object? sunHoursMax = null,Object? sunlightIntensity = null,Object? waterRequirement = null,Object? idealTempMin = null,Object? idealTempMax = null,Object? altitudeMin = null,Object? altitudeMax = null,Object? preferredKoppenTypes = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,minHarvestDays: null == minHarvestDays ? _self.minHarvestDays : minHarvestDays // ignore: cast_nullable_to_non_nullable
as int,maxHarvestDays: null == maxHarvestDays ? _self.maxHarvestDays : maxHarvestDays // ignore: cast_nullable_to_non_nullable
as int,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,soilType: null == soilType ? _self.soilType : soilType // ignore: cast_nullable_to_non_nullable
as String,soilPhMin: null == soilPhMin ? _self.soilPhMin : soilPhMin // ignore: cast_nullable_to_non_nullable
as double,soilPhMax: null == soilPhMax ? _self.soilPhMax : soilPhMax // ignore: cast_nullable_to_non_nullable
as double,sunHoursMin: null == sunHoursMin ? _self.sunHoursMin : sunHoursMin // ignore: cast_nullable_to_non_nullable
as int,sunHoursMax: null == sunHoursMax ? _self.sunHoursMax : sunHoursMax // ignore: cast_nullable_to_non_nullable
as int,sunlightIntensity: null == sunlightIntensity ? _self.sunlightIntensity : sunlightIntensity // ignore: cast_nullable_to_non_nullable
as String,waterRequirement: null == waterRequirement ? _self.waterRequirement : waterRequirement // ignore: cast_nullable_to_non_nullable
as String,idealTempMin: null == idealTempMin ? _self.idealTempMin : idealTempMin // ignore: cast_nullable_to_non_nullable
as double,idealTempMax: null == idealTempMax ? _self.idealTempMax : idealTempMax // ignore: cast_nullable_to_non_nullable
as double,altitudeMin: null == altitudeMin ? _self.altitudeMin : altitudeMin // ignore: cast_nullable_to_non_nullable
as int,altitudeMax: null == altitudeMax ? _self.altitudeMax : altitudeMax // ignore: cast_nullable_to_non_nullable
as int,preferredKoppenTypes: null == preferredKoppenTypes ? _self.preferredKoppenTypes : preferredKoppenTypes // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Crop].
extension CropPatterns on Crop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Crop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Crop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Crop value)  $default,){
final _that = this;
switch (_that) {
case _Crop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Crop value)?  $default,){
final _that = this;
switch (_that) {
case _Crop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String shortDescription,  int minHarvestDays,  int maxHarvestDays,  String difficulty,  String soilType,  double soilPhMin,  double soilPhMax,  int sunHoursMin,  int sunHoursMax,  String sunlightIntensity,  String waterRequirement,  double idealTempMin,  double idealTempMax,  int altitudeMin,  int altitudeMax,  List<String> preferredKoppenTypes,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Crop() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.minHarvestDays,_that.maxHarvestDays,_that.difficulty,_that.soilType,_that.soilPhMin,_that.soilPhMax,_that.sunHoursMin,_that.sunHoursMax,_that.sunlightIntensity,_that.waterRequirement,_that.idealTempMin,_that.idealTempMax,_that.altitudeMin,_that.altitudeMax,_that.preferredKoppenTypes,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String shortDescription,  int minHarvestDays,  int maxHarvestDays,  String difficulty,  String soilType,  double soilPhMin,  double soilPhMax,  int sunHoursMin,  int sunHoursMax,  String sunlightIntensity,  String waterRequirement,  double idealTempMin,  double idealTempMax,  int altitudeMin,  int altitudeMax,  List<String> preferredKoppenTypes,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _Crop():
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.minHarvestDays,_that.maxHarvestDays,_that.difficulty,_that.soilType,_that.soilPhMin,_that.soilPhMax,_that.sunHoursMin,_that.sunHoursMax,_that.sunlightIntensity,_that.waterRequirement,_that.idealTempMin,_that.idealTempMax,_that.altitudeMin,_that.altitudeMax,_that.preferredKoppenTypes,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String shortDescription,  int minHarvestDays,  int maxHarvestDays,  String difficulty,  String soilType,  double soilPhMin,  double soilPhMax,  int sunHoursMin,  int sunHoursMax,  String sunlightIntensity,  String waterRequirement,  double idealTempMin,  double idealTempMax,  int altitudeMin,  int altitudeMax,  List<String> preferredKoppenTypes,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _Crop() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.minHarvestDays,_that.maxHarvestDays,_that.difficulty,_that.soilType,_that.soilPhMin,_that.soilPhMax,_that.sunHoursMin,_that.sunHoursMax,_that.sunlightIntensity,_that.waterRequirement,_that.idealTempMin,_that.idealTempMax,_that.altitudeMin,_that.altitudeMax,_that.preferredKoppenTypes,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Crop implements Crop {
  const _Crop({required this.id, required this.name, required this.slug, required this.shortDescription, required this.minHarvestDays, required this.maxHarvestDays, required this.difficulty, required this.soilType, required this.soilPhMin, required this.soilPhMax, required this.sunHoursMin, required this.sunHoursMax, required this.sunlightIntensity, required this.waterRequirement, required this.idealTempMin, required this.idealTempMax, required this.altitudeMin, required this.altitudeMax, required final  List<String> preferredKoppenTypes, required final  List<String> images}): _preferredKoppenTypes = preferredKoppenTypes,_images = images;
  factory _Crop.fromJson(Map<String, dynamic> json) => _$CropFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String shortDescription;
@override final  int minHarvestDays;
@override final  int maxHarvestDays;
@override final  String difficulty;
@override final  String soilType;
@override final  double soilPhMin;
@override final  double soilPhMax;
@override final  int sunHoursMin;
@override final  int sunHoursMax;
@override final  String sunlightIntensity;
@override final  String waterRequirement;
@override final  double idealTempMin;
@override final  double idealTempMax;
@override final  int altitudeMin;
@override final  int altitudeMax;
 final  List<String> _preferredKoppenTypes;
@override List<String> get preferredKoppenTypes {
  if (_preferredKoppenTypes is EqualUnmodifiableListView) return _preferredKoppenTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferredKoppenTypes);
}

 final  List<String> _images;
@override List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CropCopyWith<_Crop> get copyWith => __$CropCopyWithImpl<_Crop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CropToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Crop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.minHarvestDays, minHarvestDays) || other.minHarvestDays == minHarvestDays)&&(identical(other.maxHarvestDays, maxHarvestDays) || other.maxHarvestDays == maxHarvestDays)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.soilType, soilType) || other.soilType == soilType)&&(identical(other.soilPhMin, soilPhMin) || other.soilPhMin == soilPhMin)&&(identical(other.soilPhMax, soilPhMax) || other.soilPhMax == soilPhMax)&&(identical(other.sunHoursMin, sunHoursMin) || other.sunHoursMin == sunHoursMin)&&(identical(other.sunHoursMax, sunHoursMax) || other.sunHoursMax == sunHoursMax)&&(identical(other.sunlightIntensity, sunlightIntensity) || other.sunlightIntensity == sunlightIntensity)&&(identical(other.waterRequirement, waterRequirement) || other.waterRequirement == waterRequirement)&&(identical(other.idealTempMin, idealTempMin) || other.idealTempMin == idealTempMin)&&(identical(other.idealTempMax, idealTempMax) || other.idealTempMax == idealTempMax)&&(identical(other.altitudeMin, altitudeMin) || other.altitudeMin == altitudeMin)&&(identical(other.altitudeMax, altitudeMax) || other.altitudeMax == altitudeMax)&&const DeepCollectionEquality().equals(other._preferredKoppenTypes, _preferredKoppenTypes)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,slug,shortDescription,minHarvestDays,maxHarvestDays,difficulty,soilType,soilPhMin,soilPhMax,sunHoursMin,sunHoursMax,sunlightIntensity,waterRequirement,idealTempMin,idealTempMax,altitudeMin,altitudeMax,const DeepCollectionEquality().hash(_preferredKoppenTypes),const DeepCollectionEquality().hash(_images)]);

@override
String toString() {
  return 'Crop(id: $id, name: $name, slug: $slug, shortDescription: $shortDescription, minHarvestDays: $minHarvestDays, maxHarvestDays: $maxHarvestDays, difficulty: $difficulty, soilType: $soilType, soilPhMin: $soilPhMin, soilPhMax: $soilPhMax, sunHoursMin: $sunHoursMin, sunHoursMax: $sunHoursMax, sunlightIntensity: $sunlightIntensity, waterRequirement: $waterRequirement, idealTempMin: $idealTempMin, idealTempMax: $idealTempMax, altitudeMin: $altitudeMin, altitudeMax: $altitudeMax, preferredKoppenTypes: $preferredKoppenTypes, images: $images)';
}


}

/// @nodoc
abstract mixin class _$CropCopyWith<$Res> implements $CropCopyWith<$Res> {
  factory _$CropCopyWith(_Crop value, $Res Function(_Crop) _then) = __$CropCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String shortDescription, int minHarvestDays, int maxHarvestDays, String difficulty, String soilType, double soilPhMin, double soilPhMax, int sunHoursMin, int sunHoursMax, String sunlightIntensity, String waterRequirement, double idealTempMin, double idealTempMax, int altitudeMin, int altitudeMax, List<String> preferredKoppenTypes, List<String> images
});




}
/// @nodoc
class __$CropCopyWithImpl<$Res>
    implements _$CropCopyWith<$Res> {
  __$CropCopyWithImpl(this._self, this._then);

  final _Crop _self;
  final $Res Function(_Crop) _then;

/// Create a copy of Crop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? shortDescription = null,Object? minHarvestDays = null,Object? maxHarvestDays = null,Object? difficulty = null,Object? soilType = null,Object? soilPhMin = null,Object? soilPhMax = null,Object? sunHoursMin = null,Object? sunHoursMax = null,Object? sunlightIntensity = null,Object? waterRequirement = null,Object? idealTempMin = null,Object? idealTempMax = null,Object? altitudeMin = null,Object? altitudeMax = null,Object? preferredKoppenTypes = null,Object? images = null,}) {
  return _then(_Crop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,minHarvestDays: null == minHarvestDays ? _self.minHarvestDays : minHarvestDays // ignore: cast_nullable_to_non_nullable
as int,maxHarvestDays: null == maxHarvestDays ? _self.maxHarvestDays : maxHarvestDays // ignore: cast_nullable_to_non_nullable
as int,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,soilType: null == soilType ? _self.soilType : soilType // ignore: cast_nullable_to_non_nullable
as String,soilPhMin: null == soilPhMin ? _self.soilPhMin : soilPhMin // ignore: cast_nullable_to_non_nullable
as double,soilPhMax: null == soilPhMax ? _self.soilPhMax : soilPhMax // ignore: cast_nullable_to_non_nullable
as double,sunHoursMin: null == sunHoursMin ? _self.sunHoursMin : sunHoursMin // ignore: cast_nullable_to_non_nullable
as int,sunHoursMax: null == sunHoursMax ? _self.sunHoursMax : sunHoursMax // ignore: cast_nullable_to_non_nullable
as int,sunlightIntensity: null == sunlightIntensity ? _self.sunlightIntensity : sunlightIntensity // ignore: cast_nullable_to_non_nullable
as String,waterRequirement: null == waterRequirement ? _self.waterRequirement : waterRequirement // ignore: cast_nullable_to_non_nullable
as String,idealTempMin: null == idealTempMin ? _self.idealTempMin : idealTempMin // ignore: cast_nullable_to_non_nullable
as double,idealTempMax: null == idealTempMax ? _self.idealTempMax : idealTempMax // ignore: cast_nullable_to_non_nullable
as double,altitudeMin: null == altitudeMin ? _self.altitudeMin : altitudeMin // ignore: cast_nullable_to_non_nullable
as int,altitudeMax: null == altitudeMax ? _self.altitudeMax : altitudeMax // ignore: cast_nullable_to_non_nullable
as int,preferredKoppenTypes: null == preferredKoppenTypes ? _self._preferredKoppenTypes : preferredKoppenTypes // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
