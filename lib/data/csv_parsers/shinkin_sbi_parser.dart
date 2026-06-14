import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../models/asset_snapshot.dart';

/// 住信SBIネット銀行 残高照会CSVをパースする
/// 列構成例: 日付,口座名義,残高
class ShinkinSBIParser {
  static const _uuid = Uuid();

  static List<AssetSnapshot> parse(String csvContent) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.length < 2) return [];

    final header = rows.first.map((e) => e.toString().trim()).toList();
    final dateIdx = header.indexWhere((h) => h.contains('日付') || h.contains('年月日'));
    final balanceIdx = header.indexWhere((h) => h.contains('残高') || h.contains('金額'));

    // ヘッダーが見つからない場合、固定列順で試みる (日付=0, 残高=最終列)
    final dIdx = dateIdx >= 0 ? dateIdx : 0;
    final bIdx = balanceIdx >= 0 ? balanceIdx : header.length - 1;

    final snapshots = <AssetSnapshot>[];
    for (final row in rows.skip(1)) {
      if (row.isEmpty) continue;
      final rawDate = row[dIdx].toString().trim();
      final rawBalance = row[bIdx].toString().replaceAll(RegExp(r'[,¥￥\s]'), '');
      final date = _parseDate(rawDate);
      final balance = double.tryParse(rawBalance);
      if (date == null || balance == null) continue;

      snapshots.add(AssetSnapshot(
        id: _uuid.v4(),
        date: date,
        totalAmount: balance,
        source: AssetSource.shinkinSbi,
        breakdown: {'住信SBI普通預金': balance},
      ));
    }
    return snapshots;
  }

  static DateTime? _parseDate(String s) {
    final clean = s.replaceAll('/', '-').replaceAll('.', '-');
    // yyyyMMdd 形式にも対応
    if (clean.length == 8 && !clean.contains('-')) {
      return DateTime.tryParse(
          '${clean.substring(0, 4)}-${clean.substring(4, 6)}-${clean.substring(6, 8)}');
    }
    return DateTime.tryParse(clean);
  }
}
