import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import '../models/asset_snapshot.dart';

/// SBI証券 保有証券一覧CSVをパースする
/// 列構成例（国内株）: 銘柄名,銘柄コード,保有数量,平均取得単価,現在値,評価額,...
/// 列構成例（投資信託）: ファンド名,保有口数,基準価額,評価額,...
/// 合計行またはサマリー行から評価額合計を取得する
class SbiSecuritiesParser {
  static const _uuid = Uuid();

  static List<AssetSnapshot> parse(String csvContent) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvContent);
    if (rows.isEmpty) return [];

    // 「評価額」列を探す
    double total = 0;
    final breakdown = <String, double>{};

    for (final row in rows) {
      if (row.isEmpty) continue;
      final cells = row.map((e) => e.toString().trim()).toList();

      // 合計行を探す（「合計」「評価額合計」など）
      if (_isTotalRow(cells)) {
        final val = _extractAmount(cells);
        if (val != null) {
          total = val;
          break;
        }
      }

      // 各銘柄行から評価額を加算
      final amount = _extractRowAmount(cells);
      final name = cells.isNotEmpty ? cells[0] : '';
      if (amount != null && amount > 0 && name.isNotEmpty && !_isHeader(cells)) {
        breakdown[name] = (breakdown[name] ?? 0) + amount;
        total += amount;
      }
    }

    // 合計行が見つかった場合はbreakdownの集計より優先
    if (total <= 0) return [];

    return [
      AssetSnapshot(
        id: _uuid.v4(),
        date: DateTime.now(),
        totalAmount: total,
        source: AssetSource.sbiSecurities,
        breakdown: breakdown.isNotEmpty ? breakdown : {'SBI証券': total},
      )
    ];
  }

  static bool _isTotalRow(List<String> cells) {
    final text = cells.join('');
    return text.contains('合計') &&
        (text.contains('評価') || text.contains('残高'));
  }

  static bool _isHeader(List<String> cells) {
    final text = cells.join('');
    return text.contains('銘柄名') ||
        text.contains('ファンド') ||
        text.contains('保有数量') ||
        text.contains('評価額');
  }

  static double? _extractAmount(List<String> cells) {
    // 後ろから数値を探す
    for (int i = cells.length - 1; i >= 0; i--) {
      final val = double.tryParse(
          cells[i].replaceAll(RegExp(r'[,¥￥\s円]'), ''));
      if (val != null && val > 0) return val;
    }
    return null;
  }

  static double? _extractRowAmount(List<String> cells) {
    // 「評価額」は通常後方の列にある
    // 右から3列以内で最初に見つかった数値を評価額とする
    final start = (cells.length - 3).clamp(0, cells.length);
    for (int i = cells.length - 1; i >= start; i--) {
      final val = double.tryParse(
          cells[i].replaceAll(RegExp(r'[,¥￥\s円]'), ''));
      if (val != null && val > 0) return val;
    }
    return null;
  }
}
