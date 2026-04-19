import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/resume_report.dart';

class PdfService {
  String extractText(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);
    final text = extractor.extractText();
    document.dispose();
    return text;
  }

  Future<Uint8List> buildResumeSuggestionReport(ResumeReport report) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'AI Resume Improvement Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Overall Score: ${report.overallScore}/100'),
          pw.Text('ATS Score: ${report.atsScore}/100 (${report.atsStatus})'),
          pw.SizedBox(height: 14),
          pw.Text('Strengths', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...report.strengths.map((e) => pw.Bullet(text: e)),
          pw.SizedBox(height: 10),
          pw.Text('Improvements', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...report.improvements.map(
            (i) => pw.Bullet(text: '[${i.priority.toUpperCase()}] ${i.suggestion} | Example: ${i.example}'),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Missing Keywords', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(report.missingKeywords.join(', ')),
          pw.SizedBox(height: 10),
          pw.Text('Summary', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(report.summary),
        ],
      ),
    );

    return doc.save();
  }
}
