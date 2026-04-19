import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../services/gemini_service.dart';

class SummarizeLessonScreen extends StatefulWidget {
  const SummarizeLessonScreen({super.key});

  @override
  State<SummarizeLessonScreen> createState() => _SummarizeLessonScreenState();
}

class _SummarizeLessonScreenState extends State<SummarizeLessonScreen> {
  String? selectedFileName;
  String? selectedFilePath;
  bool isSummarizing = false;
  String summaryText = "";
  List<String> summaryChips = []; // قائمة المصطلحات المهمة
  String extractedContent = ""; // هنخزن النص الأصلي عشان الكويز يستخدمه

  // 1. اختيار الملف
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        selectedFilePath = result.files.single.path;
        summaryText = "";
        summaryChips = [];
      });
    }
  }

  // 2. التلخيص واستخراج الـ Chips
  Future<void> generateSummary() async {
    if (selectedFilePath == null) return;

    setState(() {
      isSummarizing = true;
      summaryText = "جاري تحليل الملف واستخراج الخريطة الذهنية... 🤖⏳";
    });

    try {
      final File file = File(selectedFilePath!);
      final List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      extractedContent = PdfTextExtractor(document).extractText();
      document.dispose();

      if (extractedContent.trim().isEmpty) {
        setState(() {
          summaryText = "الملف فاضي يا صاحبي!";
          isSummarizing = false;
        });
        return;
      }

      const int maxPdfChars = 30000;
      if (extractedContent.length > maxPdfChars) {
        setState(() {
          summaryText =
              "الملف كبير جداً (أكثر من $maxPdfChars حرف). من فضلك ارفع ملفاً أقصر.";
          isSummarizing = false;
        });
        return;
      }

      final prompt = '''
      أنت معلم خبير. بناءً على النص التالي:
      1. لخص الدرس في نقاط بسيطة ومنظمة.
      2. استخرج أهم 5 مصطلحات تكنولوجية أو مفاهيم أساسية وردت في النص وضعها في سطر واحد مفصولة بـ علامة "|".

      ابدأ الرد بالتلخيص، ثم ضع في النهاية السطر التالي تماماً: "CHIPS:" متبوعاً بالمصطلحات.

      النص: $extractedContent
      ''';

      final fullText = await GeminiService.generate(
        prompt,
        maxInputChars: maxPdfChars + 2000,
      );

      // فصل الـ Chips عن النص
      if (fullText.contains("CHIPS:")) {
        List<String> parts = fullText.split("CHIPS:");
        setState(() {
          summaryText = parts[0].trim();
          summaryChips = parts[1].split("|").map((e) => e.trim()).toList();
        });
      } else {
        setState(() { summaryText = fullText; });
      }

    }
    catch (e) {
      debugPrint("System Error: $e");
      setState(() {
        if (e.toString().toLowerCase().contains('quota') || e.toString().contains('429')) {
          summaryText = "استهلكت الحد الأقصى للطلبات! يرجى الانتظار دقيقة والمحاولة مرة أخرى. ⏳";
        } else {
          summaryText = "حدث خطأ غير متوقع:\n$e";
        }
      });
    }
    finally {
      setState(() { isSummarizing = false; });
    }
  }

  // 3. دالة بدء الكويز
  void startAIQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("استعد للكويز! 🎯", style: TextStyle(color: Colors.white), textAlign: TextAlign.right),
        content: const Text("سيقوم المعلم الذكي بإنشاء 3 أسئلة بناءً على ما ذاكرته الآن.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("بدء الآن")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("ذاكر بذكاء 🧠", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: pickPDF,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selectedFileName == null ? Colors.blueAccent.withOpacity(0.5) : Colors.green, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(selectedFileName == null ? Icons.upload_file : Icons.check_circle, color: selectedFileName == null ? Colors.blueAccent : Colors.green, size: 40),
                    Text(selectedFileName ?? "ارفع ملف الـ ICT هنا", style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: selectedFileName == null || isSummarizing ? null : generateSummary,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: isSummarizing ? const CircularProgressIndicator(color: Colors.white) : const Text("ابدأ التحليل والشرح 🚀", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            if (summaryChips.isNotEmpty) ...[
              const Text("أهم مفاهيم الدرس:", style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.right),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8, alignment: WrapAlignment.end,
                children: summaryChips.map((chip) => Chip(
                  label: Text(chip, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  side: const BorderSide(color: Colors.blueAccent),
                )).toList(),
              ),
              const SizedBox(height: 20),
            ],

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: Text(
                    summaryText.isEmpty ? "ارفع الملف عشان نطلعلك الزتونة... 💡" : summaryText,
                    style: TextStyle(color: Colors.grey[300], fontSize: 16, height: 1.5),
                    textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            if (summaryText.isNotEmpty && !isSummarizing)
              ElevatedButton.icon(
                onPressed: startAIQuiz,
                icon: const Icon(Icons.quiz, color: Colors.white),
                label: const Text("اختبر نفسك في هذا الدرس 🎯", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
          ],
        ),
      ),
    );
  }
}