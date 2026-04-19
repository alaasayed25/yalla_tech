import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TestAIScreen extends StatefulWidget {
  const TestAIScreen({super.key});

  @override
  State<TestAIScreen> createState() => _TestAIScreenState();
}

class _TestAIScreenState extends State<TestAIScreen> {
  String aiResponse = "الإجابة هتظهر هنا...";
  bool isLoading = false;

  // الدالة دي اللي هنجرب بيها الـ AI بجد
  Future<void> testAIConnection() async {
    setState(() {
      isLoading = true;
      aiResponse = "جاري الاتصال بالذكاء الاصطناعي... ⏳";
    });

    try {
      // ⚠️ حط مفتاح الـ API بتاعك هنا بين علامات التنصيص
      const apiKey = 'AIzaSyD_MU2A8_-kU0YI7f4s_YB2RjbzTUWZktQ';

      // بنحدد الموديل اللي هنستخدمه (flash سريع وممتاز للتجربة)
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      // الرسالة اللي هنبعتها للـ AI
      const prompt = 'أنا طالب في هندسة برمجيات مبتدئ، قولي إيه هي أهم 5 أدوات أو تقنيات لازم أتعلمهم، واكتبلي سطر واحد شرح لكل أداة بالعربي.';      final content = [Content.text(prompt)];

      // بنستنى الرد
      final response = await model.generateContent(content);

      setState(() {
        // بنعرض الرد اللي رجع
        aiResponse = response.text ?? "الذكاء الاصطناعي ماردش بحاجة!";
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        aiResponse = "حصلت مشكلة: $e ❌\nاتأكد من الـ API Key أو النت.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text("Test AI", style: TextStyle(color: Color(0xFF00E5FF))),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: isLoading ? null : testAIConnection,
              child: const Text(
                "اضغط لتجربة الـ AI",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
                  : Text(
                aiResponse,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}