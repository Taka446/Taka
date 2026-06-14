enum AssetSource { moneyforward, shinkinSbi, smcc, manual }

class AssetSnapshot {
  final String id;
  final DateTime date;
  final double totalAmount;
  final AssetSource source;
  final Map<String, double> breakdown; // カテゴリ名→金額

  const AssetSnapshot({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.source,
    required this.breakdown,
  });
}
