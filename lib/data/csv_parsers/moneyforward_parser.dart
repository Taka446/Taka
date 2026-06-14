import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../models/asset_snapshot.dart';

/// マネーフォワードME の「資産推移CSV」をパースする
/// 列構成例: 日付,現金・プリペイド,預金・貯金,株式(現物),投資信託,..合計
class MoneyForwardParser {
  static const _uuid = Uuid();

  static List<AssetSnapshot> parse(String csvContent) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.length < 2) return [];

    final header = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = header.indexOf('日付');
    final totalIdx = header.indexWhere(
        (h) => h.contains('合計') || h.contains('総資産'));

    if (dateIdx < 0 || totalIdx < 0) return [];

    final snapshots = <AssetSnapshot>[];
    for (final row in rows.skip(1)) {
      if (row.length <= totalIdx) continue;
      final rawDate = row[dateIdx].toString().trim();
      final rawTotal = row[totalIdx].toString().replaceAll(RegExp(r'[,¥￥\s]'), '');
      final date = _parseDate(rawDate);
      final total = double.tryParse(rawTotal);
      if (date == null || total == null) continue;

      // 内訳マップ (合計列以外をすべて収録)
      final breakdown = <String, double>{};
      for (int i = 0; i < header.length; i++) {
        if (i == dateIdx || i == totalIdx) continue;
        final val = double.tryParse(
            row[i].toString().replaceAll(RegExp(r'[,¥￥\s]'), ''));
        if (val != null && val != 0) breakdown[header[i]] = val;
      }

      snapshots.add(AssetSnapshot(
        id: _uuid.v4(),
        date: date,
        totalAmount: total,
        source: AssetSource.moneyforward,
        breakdown: breakdown,
      ));
    }
    return snapshots;
  }

  static DateTime? _parseDate(String s) {
    // yyyy/MM/dd or yyyy-MM-dd
    final clean = s.replaceAll('/', '-');
    return DateTime.tryParse(clean);
  }
}
