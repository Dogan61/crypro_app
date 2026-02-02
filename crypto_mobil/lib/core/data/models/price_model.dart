import 'package:crypto_mobil/core/domain/entities/price_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'price_model.g.dart';

@JsonSerializable()
class PriceModel extends PriceEntity {
  const PriceModel({required super.symbol, required super.price});

  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceModelToJson(this);
}
