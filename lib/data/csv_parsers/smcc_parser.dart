import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../models/asset_snapshot.dart';

/// 三井住友カード 利用明細CSVをパースする
/// 列構成例: 利用日,利用店名,利用金額,支払い金額,...
/// ※ カードはマイナス資産（負債）として扱う
class SmccParser {
  static const _uuid = Uuid();

  static List<AssetSnapshot> parse(String csvContent) {
    // Shift-JISで来る場合があるが、flutter の file_picker は文字列として渡す想定
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.length < 2) return [];

    final header = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = header.indexWhere((h) => h.contains('利用日') || h.contains('日付'));
    final amountIdx = header.indexWhere(
        (h) => h.contains('利用金額') || h.contains('金額'));
    if (dateIdx < 0 || amountIdx < 0) return [];

    // 月ごとに合計して1スナップショットにまとめる
    final monthlyTotals = <String, double>{};
    for (final row in rows.skip(1)) {
      if (row.length <= amountIdx) continue;
      final rawDate = row[dateIdx].toString().trim();
      final rawAmount = row[amountIdx].toString().replaceAll(RegExp(r'[,¥￥\s]'), '');
      final date = _parseDate(rawDate);
      final amount = double.tryParse(rawAmount);
      if (date == null || amount == null) continue;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      monthlyTotals[key] = (monthlyTotals[key] ?? 0) + amount;
    }

    return monthlyTotals.entries.map((e) {
      final parts = e.key.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
      // カード利用はマイナス（負債）
      return AssetSnapshot(
        id: _uuid.v4(),
        date: date,
        totalAmount: -e.value,
        source: AssetSource.smcc,
        breakdown: {'三井住友カード利用': -e.value},
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static DateTime? _parseDate(String s) {
    final clean = s.replaceAll('/', '-');
    return DateTime.tryParse(clean);
  }
}
