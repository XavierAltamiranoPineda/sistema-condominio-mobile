import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';

class ReportesPage extends ConsumerWidget {
  const ReportesPage({super.key});

  Future<void> _generarPdf(BuildContext context, String titulo) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Reporte: $titulo', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Este es un documento generado desde el Sistema Condominio Mobile.'),
              pw.SizedBox(height: 40),
              pw.TableHelper.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['Columna 1', 'Columna 2', 'Columna 3'],
                  <String>['Dato A', 'Dato B', 'Dato C'],
                  <String>['Dato X', 'Dato Y', 'Dato Z'],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Reporte_$titulo.pdf',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportes = [
      {'titulo': 'Estado de Cuenta', 'icono': Icons.account_balance_wallet},
      {'titulo': 'Historial de Pagos', 'icono': Icons.payment},
      {'titulo': 'Reporte de Morosidad', 'icono': Icons.warning},
      {'titulo': 'Directorio de Residentes', 'icono': Icons.people},
      {'titulo': 'Estado de Residencias', 'icono': Icons.house},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes PDF')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reportes.length,
        itemBuilder: (context, index) {
          final repo = reportes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: Icon(repo['icono'] as IconData, color: Colors.blue),
              ),
              title: Text(repo['titulo'] as String),
              subtitle: const Text('Generar documento PDF'),
              trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
              onTap: () => _generarPdf(context, repo['titulo'] as String),
            ),
          );
        },
      ),
    );
  }
}
