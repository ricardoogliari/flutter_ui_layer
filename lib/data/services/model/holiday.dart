import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'holiday.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Holiday extends Equatable {
  Holiday(this.date, this.localName, this.name, this.countryCode);

  String? date;
  String? localName;
  String? name;
  String? countryCode;

  factory Holiday.fromJson(Map<String, Object?> json) =>
      _$HolidayFromJson(json);

  @override
  List<Object> get props => [
    date ?? '',
    localName ?? '',
    name ?? '',
    countryCode ?? '',
  ];
}
