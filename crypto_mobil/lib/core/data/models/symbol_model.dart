import 'package:crypto_mobil/core/domain/entities/symbol_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'symbol_model.g.dart';

/// Binance /api/market/symbols cevabı camelCase alanlar döndürüyor
/// (symbol, baseAsset, quoteAsset, status).
/// Global `build.yaml` snake_case ayarı bu model için geçerli olmamalı.
@JsonSerializable(fieldRename: FieldRename.none)
class SymbolModel extends SymbolEntity {
  const SymbolModel({
    required super.symbol,
    required super.baseAsset,
    required super.quoteAsset,
    required super.status,
  });

  factory SymbolModel.fromJson(Map<String, dynamic> json) =>
      _$SymbolModelFromJson(json);

  Map<String, dynamic> toJson() => _$SymbolModelToJson(this);
}
