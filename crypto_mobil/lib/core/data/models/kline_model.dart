import 'package:crypto_mobil/core/domain/entities/kline_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kline_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class KlineModel extends KlineEntity {
  const KlineModel({
    required super.openTime,
    required super.open,
    required super.high,
    required super.low,
    required super.close,
    required super.volume,
    required super.closeTime,
    required super.quoteVolume,
    required super.trades,
  });

  factory KlineModel.fromJson(Map<String, dynamic> json) =>
      _$KlineModelFromJson(json);

  Map<String, dynamic> toJson() => _$KlineModelToJson(this);
}
