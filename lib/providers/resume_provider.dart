import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../models/resume_report.dart';
import '../services/gemini_service.dart';
import '../services/pdf_service.dart';

final resumeProvider = ChangeNotifierProvider<ResumeProvider>((ref) {
  return ResumeProvider(
    geminiService: CareerGeminiService(),
    pdfService: PdfService(),
  );
});

class ResumeProvider extends ChangeNotifier {
  ResumeProvider({
    required CareerGeminiService geminiService,
    required PdfService pdfService,
  })  : _geminiService = geminiService,
        _pdfService = pdfService;

  final CareerGeminiService _geminiService;
  final PdfService _pdfService;

  bool isLoading = false;
  String? error;
  String resumeText = '';
  ResumeReport? report;

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) return;

      final bytes = result.files.single.bytes!;
      resumeText = _pdfService.extractText(bytes);
      notifyListeners();
    } catch (e) {
      error = 'Failed to read PDF: $e';
      notifyListeners();
    }
  }

  Future<void> analyzeResume(String text) async {
    isLoading = true;
    error = null;
    report = null;
    notifyListeners();

    try {
      final response = await _geminiService.generateJson(
        prompt: '''
You are an expert ATS resume checker and career coach.
Analyze the following resume and return ONLY a JSON object with this exact structure:
{
  "overallScore": 0,
  "atsScore": 0,
  "atsStatus": "ATS Friendly / Not ATS Friendly / Needs Work",
  "sections": {
    "contact": {"score": 0, "status": "good/warning/missing", "feedback": "..."},
    "summary": {"score": 0, "status": "good/warning/missing", "feedback": "..."},
    "experience": {"score": 0, "status": "good/warning/missing", "feedback": "..."},
    "skills": {"score": 0, "status": "good/warning/missing", "feedback": "..."},
    "education": {"score": 0, "status": "good/warning/missing", "feedback": "..."},
    "projects": {"score": 0, "status": "good/warning/missing", "feedback": "..."}
  },
  "strengths": ["..."],
  "weaknesses": ["..."],
  "improvements": [{"priority": "high/medium/low", "suggestion": "...", "example": "..."}],
  "missingKeywords": ["..."],
  "formattingIssues": ["..."],
  "actionVerbs": {"present": ["..."], "missing": ["..."]},
  "quantificationScore": 0,
  "summary": "..."
}
Resume content:
$text
''',
      );

      report = ResumeReport.fromJson(response);
    } catch (e) {
      error = 'Resume analysis failed: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadSuggestionPdf() async {
    if (report == null) return;

    final bytes = await _pdfService.buildResumeSuggestionReport(report!);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'resume_improvement_report.pdf',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resumeText': resumeText,
      'hasReport': report != null,
    };
  }

  String exportRawAnalysis() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}
