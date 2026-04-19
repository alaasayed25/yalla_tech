import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // الألوان الأساسية
  final Color backgroundColor = const Color(0xFF0D1B2A);
  final Color cardColor = const Color(0xFF1B263B);
  final Color primaryCyan = const Color(0xFF00E5FF);

  // لستة الأسئلة والإجابات
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'إيه أكتر حاجة بتلفت انتباهك لما تفتح أي أبلكيشن جديد؟',
      'options': [
        'الألوان، التصميم، وسهولة الاستخدام.',
        'السرعة، وإزاي البيانات بتتحفظ وتظهر من غير مشاكل.',
        'الذكاء في اقتراح حاجات تناسبني وتوقع تصرفاتي.'
      ]
    },
    {
      'question': 'لما بتيجي تحل مشكلة، بتفضل تفكر إزاي؟',
      'options': [
        'أرسم شكل تخيلي للحل وأجرب ألوان وأشكال.',
        'أكتب خطوات منطقية (1، 2، 3) وأربط الحاجات ببعض.',
        'أدور على نمط متكرر (Pattern) في المشكلة وأحللها.'
      ]
    },
    {
      'question': 'نفسك تبني إيه في المستقبل؟',
      'options': [
        'مواقع وتطبيقات مبهرة الناس تتفاعل معاها يومياً.',
        'أنظمة قوية للبنوك والشركات الكبيرة تتحمل ضغط.',
        'أنظمة ذكاء اصطناعي وبرامج بتتعلم لوحدها.'
      ]
    },
  ];

  // متغيرات عشان نحفظ حالة الشاشة
  int _currentQuestionIndex = 0;
  List<String> _userAnswers = [];
  bool _isLoading = false;
  String? _aiResult; // النتيجة اللي هترجع من الذكاء الاصطناعي

  // الدالة اللي بتشتغل لما الطالب يختار إجابة
  void _answerQuestion(String answer) {
    setState(() {
      _userAnswers.add(answer); // نحفظ الإجابة

      if (_currentQuestionIndex < _questions.length - 1) {
        // لو لسه في أسئلة، انقل على السؤال اللي بعده
        _currentQuestionIndex++;
      } else {
        // لو الأسئلة خلصت، كلم الذكاء الاصطناعي
        _getAIRecommendation();
      }
    });
  }

  // الدالة اللي بتكلم الـ AI بجد بناءً على إجابات الطالب
  Future<void> _getAIRecommendation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ⚠️ حط الـ API Key بتاعك هنا
      const apiKey = 'AIzaSyD_MU2A8_-kU0YI7f4s_YB2RjbzTUWZktQ';
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      // بنجمع الإجابات في رسالة واحدة للـ AI
      String prompt = '''
      أنا طالب مبتدئ وعايز أعرف التراك البرمجي المناسب ليا. دي إجاباتي على 3 أسئلة:
      1. الإجابة الأولى: ${_userAnswers[0]}
      2. الإجابة التانية: ${_userAnswers[1]}
      3. الإجابة التالتة: ${_userAnswers[2]}
      
      بناءً على الإجابات دي، اقترح لي تراك برمجي واحد بس (مثلاً: Frontend أو Backend أو AI أو Mobile).
      اكتب اسم التراك بشكل واضح، وبعدها اكتب سطرين بس باللغة العربية تشرحلي فيهم ليه التراك ده مناسب ليا.
      ''';

      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _aiResult = response.text ?? "مقدرتش أحدد مسار للأسف.";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _aiResult = "حصلت مشكلة في الاتصال: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text("AI Career Match", style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: primaryCyan),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildBodyContent(),
      ),
    );
  }

  // دالة بتحدد إيه اللي هيتعرض في الشاشة بناءً على الحالة
  Widget _buildBodyContent() {
    // 1. لو بيحمل (بيكلم الـ AI)
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryCyan),
          const SizedBox(height: 20),
          const Text(
            "الذكاء الاصطناعي بيحلل إجاباتك وبيجهز مسارك... 🧠⏳",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // 2. لو الـ AI رد علينا بالنتيجة
    if (_aiResult != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.stars, color: primaryCyan, size: 80),
          const SizedBox(height: 20),
          const Text(
            "المسار المقترح ليك هو:",
            style: TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryCyan.withOpacity(0.5)),
            ),
            child: Text(
              _aiResult!,
              style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl, // عشان العربي يظهر مظبوط
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryCyan,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: () => Navigator.pop(context), // يرجع للشاشة الرئيسية
            child: const Text("العودة للرئيسية", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }

    // 3. لو لسه بيجاوب على الأسئلة
    final currentQ = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "سؤال ${_currentQuestionIndex + 1} من ${_questions.length}",
          style: TextStyle(color: primaryCyan, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          currentQ['question'],
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 30),
        // عرض الاختيارات كزراير
        ...(currentQ['options'] as List<String>).map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _answerQuestion(option),
              child: Text(
                option,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }),
      ],
    );
  }
}