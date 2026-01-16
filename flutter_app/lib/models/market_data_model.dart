class MarketData {
  final String symbol;
  final String? description;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;
  final double? high24h;
  final double? low24h;
  final double? marketCap;
  final String? lastUpdated;

  MarketData({
    required this.symbol,
    this.description,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
    this.high24h,
    this.low24h,
    this.marketCap,
    this.lastUpdated,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      symbol: json['symbol'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      change24h: (json['change24h'] as num).toDouble(),
      changePercent24h: (json['changePercent24h'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      high24h: json['high24h'] != null ? (json['high24h'] as num).toDouble() : null,
      low24h: json['low24h'] != null ? (json['low24h'] as num).toDouble() : null,
      marketCap: json['marketCap'] != null ? (json['marketCap'] as num).toDouble() : null,
      lastUpdated: json['lastUpdated'] as String?,
    );
  }
}
