import 'package:crypto_mobil/core/domain/entities/ticker_24h_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticker_24h_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Ticker24hModel extends Ticker24hEntity {
  const Ticker24hModel({
    required super.symbol,
    required super.priceChange,
    required super.priceChangePercent,
    required super.weightedAvgPrice,
    required super.prevClosePrice,
    required super.lastPrice,
    required super.lastQty,
    required super.bidPrice,
    required super.askPrice,
    required super.openPrice,
    required super.highPrice,
    required super.lowPrice,
    required super.volume,
    required super.quoteVolume,
    required super.openTime,
    required super.closeTime,
    required super.firstId,
    required super.lastId,
    required super.count,
  });

  factory Ticker24hModel.fromJson(Map<String, dynamic> json) =>
      _$Ticker24hModelFromJson(json);

  Map<String, dynamic> toJson() => _$Ticker24hModelToJson(this);
}
