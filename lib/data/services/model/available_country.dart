import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'available_country.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class AvailableCountry {
  AvailableCountry(this.countryCode, this.name);

  String? countryCode;
  String? name;

  factory AvailableCountry.fromJson(Map<String, Object?> json) =>
      _$AvailableCountryFromJson(json);
}
