import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class PdfExportService {
  static Future<void> exportAttendancePDF({
    required String subjectName,
    required String semester,
    required int totalHours,
    required List<Map<String, dynamic>> students,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(subjectName, semester, totalHours, startDate, endDate),
          pw.SizedBox(height: 20),
          _buildStudentTable(students),
          pw.SizedBox(height: 20),
          _buildSummary(students),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeader(
      String subjectName,
      String semester,
      int totalHours,
      DateTime startDate,
      DateTime endDate,
      ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Rapport de présence',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text('Module: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(subjectName),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Semestre: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(semester),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Periode: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Heures Totales: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('$totalHours hours'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildStudentTable(List<Map<String, dynamic>> students) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              child: pw.Text(
                'No',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              padding: pw.EdgeInsets.all(4),
            ),
            pw.Padding(
              child: pw.Text(
                'Nom de l\'étudiant',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              padding: pw.EdgeInsets.all(4),
            ),
            pw.Padding(
              child: pw.Text(
                'Présent (heures)',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              padding: pw.EdgeInsets.all(4),
            ),
            pw.Padding(
              child: pw.Text(
                'Absent (heures)',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              padding: pw.EdgeInsets.all(4),
            ),
            pw.Padding(
              child: pw.Text(
                'Présence %',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              padding: pw.EdgeInsets.all(4),
            ),
          ],
        ),
        ...students.map((student) {
          final attendancePercent = (student['total_hours'] > 0)
              ? (student['present_hours'] / student['total_hours'] * 100)
              : 0;

          return pw.TableRow(
            children: [
              pw.Padding(
                child: pw.Text(
                  student['number'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
                padding: pw.EdgeInsets.all(4),
              ),
              pw.Padding(
                child: pw.Text(student['name']),
                padding: pw.EdgeInsets.all(4),
              ),
              pw.Padding(
                child: pw.Text(
                  student['present_hours'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
                padding: pw.EdgeInsets.all(4),
              ),
              pw.Padding(
                child: pw.Text(
                  student['absent_hours'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
                padding: pw.EdgeInsets.all(4),
              ),
              pw.Padding(
                child: pw.Text(
                  '${attendancePercent.toStringAsFixed(1)}%',
                  textAlign: pw.TextAlign.center,
                ),
                padding: pw.EdgeInsets.all(4),
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildSummary(List<Map<String, dynamic>> students) {
    final totalPresent = students.fold<int>(
        0, (sum, student) => sum + (student['present_hours'] as int));
    final totalAbsent = students.fold<int>(
        0, (sum, student) => sum + (student['absent_hours'] as int));
    final totalHours = totalPresent + totalAbsent;
    final overallPercentage =
    totalHours > 0 ? (totalPresent / totalHours * 100) : 0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Résumé',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Nombre total d\'étudiants :'),
            pw.Text(students.length.toString()),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Nombre total d\'heures de présence :'),
            pw.Text('$totalPresent hrs'),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Nombre total d\'heures d\'absence :'),
            pw.Text('$totalAbsent hrs'),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Présence globale :'),
            pw.Text('${overallPercentage.toStringAsFixed(1)}%'),
          ],
        ),
      ],
    );
  }
}