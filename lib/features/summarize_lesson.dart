import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

  // 1. دالة اختيار الملف (PDF فقط)
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        selectedFilePath = result.files.single.path;
        summaryText = ""; // مسح التلخيص القديم عند اختيار ملف جديد
      });
    }
  }

  // 2. دالة استخراج النص والتلخيص باستخدام Gemini AI
  Future<void> generateSummary() async {
    if (selectedFilePath == null) return;

    setState(() {
      isSummarizing = true;
      summaryText = "جاري قراءة الملف وتلخيصه، ثواني يا بطل... 🤖⏳";
    });

    try {}  catch (e) {{
      // --- أ: قراءة النص من الـ PDF ---
      final File file = File(selectedFilePath!);
      final List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // استخراج النص من كل الصفحات
      final String extractedText = PdfTextExtractor(document).extractText();
      document.dispose(); // إغلاق المستند لتحرير الذاكرة

      if (extractedText.trim().isEmpty) {
        setState(() {
          summaryText = "عذراً، الملف يبدو فارغاً أو يحتوي على صور فقط (لا يمكن قراءة النص منها حالياً) 🥲";
          isSummarizing = false;
        });
        return;
      }

      // --- ب: إرسال النص لـ Gemini للتلخيص ---
      const apiKey = 'AIzaSyBDz3NX_gYS7d0C-QhqRTrm_JYZZshx0fU';

      // استخدام موديل Flash 1.5 لأنه يدعم سعة نصوص أكبر وأسرع
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
      أنت معلم خبير وممتاز في الشرح والتبسيط. 
      قم بتلخيص النص التالي للطلاب بطريقة احترافية ومنظمة:
      1. استخدم النقاط (Bullet points).
      2. ركز على المفاهيم والمعلومات الأساسية فقط.
      3. اجعل اللغة عربية فصحى وبسيطة.
      
      النص المراد تلخيصه:
      $extractedText
      ''';

      // إرسال الطلب كقائمة من المحتوى (الأسلوب الأضمن لتجنب مشاكل الإصدارات)
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        summaryText = response.text ?? "عذراً، لم أتمكن من الحصول على رد من الذكاء الاصطناعي.";
        isSummarizing = false;
      });

    }
      debugPrint("Gemini Error: $e"); // لطباعة الخطأ بالتفصيل في الـ Debug Console
      setState(() {
        summaryText = "حصلت مشكلة أثناء التلخيص. تأكد من جودة الإنترنت أو جرب ملفاً أصغر. ❌";
        isSummarizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ثيم غامق رايق
      appBar: AppBar(
        title: const Text("تلخيص الدروس 📝",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // منطقة اختيار الملف
            GestureDetector(
              onTap: pickPDF,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selectedFileName == null ? Colors.blueAccent.withOpacity(0.5) : Colors.green,
                      width: 2
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        selectedFileName == null ? Icons.upload_file : Icons.check_circle,
                        color: selectedFileName == null ? Colors.blueAccent : Colors.green,
                        size: 50
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        selectedFileName ?? "اضغط هنا لاختيار ملف PDF",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // زر التلخيص
            ElevatedButton(
              onPressed: selectedFileName == null || isSummarizing ? null : generateSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                disabledBackgroundColor: Colors.grey[800],
              ),
              child: isSummarizing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("لخّص الملف 🚀",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 30),

            // منطقة عرض النتيجة
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    summaryText.isEmpty ? "ارفع الملف ودوس تلخيص عشان تشوف النتيجة هنا..." : summaryText,
                    style: TextStyle(color: Colors.grey[300], fontSize: 16, height: 1.5),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}