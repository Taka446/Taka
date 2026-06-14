import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/csv_parsers/moneyforward_parser.dart';
import '../../data/csv_parsers/shinkin_sbi_parser.dart';
import '../../data/csv_parsers/smcc_parser.dart';
import '../../data/csv_parsers/sbi_securities_parser.dart';
import '../providers/providers.dart';

enum ImportSource { moneyforward, shinkinSbi, smcc, sbiSecurities }

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _loading = false;
  String? _message;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CSV インポート')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '各サービスからエクスポートした CSV ファイルを選択してください。',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _ImportTile(
            title: 'マネーフォワード ME',
            subtitle: '資産推移 CSV（メニュー → 資産推移 → エクスポート）',
            icon: Icons.account_balance,
            color: const Color(0xFF0066CC),
            onImport: () => _import(ImportSource.moneyforward),
          ),
          const SizedBox(height: 12),
          _ImportTile(
            title: '住信SBIネット銀行',
            subtitle: '残高照会 CSV（口座照会 → CSV ダウンロード）',
            icon: Icons.savings,
            color: const Color(0xFF004B87),
            onImport: () => _import(ImportSource.shinkinSbi),
          ),
          const SizedBox(height: 12),
          _ImportTile(
            title: '三井住友カード',
            subtitle: '利用明細 CSV（明細照会 → CSV ダウンロード）',
            icon: Icons.credit_card,
            color: const Color(0xFF00A040),
            onImport: () => _import(ImportSource.smcc),
          ),
          const SizedBox(height: 12),
          _ImportTile(
            title: 'SBI証券',
            subtitle: '保有証券 CSV（保有証券一覧 → CSV ダウンロード）',
            icon: Icons.show_chart,
            color: const Color(0xFFE65100),
            onImport: () => _import(ImportSource.sbiSecurities),
          ),
          if (_message != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _success
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(_success ? Icons.check_circle : Icons.error,
                    color: _success ? Colors.green : Colors.red),
                const SizedBox(width: 10),
                Expanded(child: Text(_message!)),
              ]),
            ),
          ],
          if (_loading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Future<void> _import(ImportSource source) async {
    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'CSV'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _loading = false);
        return;
      }

      final bytes = result.files.first.bytes!;
      // Shift-JIS を考慮して latin1 → utf8 フォールバック
      String content;
      try {
        content = utf8.decode(bytes);
      } catch (_) {
        content = latin1.decode(bytes);
      }

      final repo = ref.read(assetRepoProvider);
      int count = 0;

      switch (source) {
        case ImportSource.moneyforward:
          final snapshots = MoneyForwardParser.parse(content);
          await repo.saveSnapshots(snapshots);
          count = snapshots.length;
        case ImportSource.shinkinSbi:
          final snapshots = ShinkinSBIParser.parse(content);
          await repo.saveSnapshots(snapshots);
          count = snapshots.length;
        case ImportSource.smcc:
          final snapshots = SmccParser.parse(content);
          await repo.saveSnapshots(snapshots);
          count = snapshots.length;
        case ImportSource.sbiSecurities:
          final snapshots = SbiSecuritiesParser.parse(content);
          await repo.saveSnapshots(snapshots);
          count = snapshots.length;
      }

      setState(() {
        _loading = false;
        _success = count > 0;
        _message = count > 0
            ? '$count 件のデータをインポートしました。'
            : 'データが見つかりませんでした。CSV 形式を確認してください。';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _success = false;
        _message = 'エラー: $e';
      });
    }
  }
}

class _ImportTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onImport;

  const _ImportTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: FilledButton.tonal(
            onPressed: onImport,
            child: const Text('選択'),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
}
