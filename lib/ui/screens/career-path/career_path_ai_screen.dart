import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class CareerPathAIScreen extends StatefulWidget {
  const CareerPathAIScreen({super.key});

  @override
  State<CareerPathAIScreen> createState() => _CareerPathAIScreenState();
}

class _CareerPathAIScreenState extends State<CareerPathAIScreen> {
  int _currentQuestionIndex = 0;
  bool _isLoadingQuestions = true;
  bool _isAnalyzing = false;
  bool _showResult = false;

  List<Map<String, dynamic>> _dynamicQuestions = [];
  final List<String> _userAnswers = [];
  String _realAiResponse = "";

  @override
  void initState() {
    super.initState();
    _userAnswers.clear();
    _dynamicQuestions.clear();
    _currentQuestionIndex = 0;
    _showResult = false;
    _generateQuestionsWithAI();
  }

  Future<void> _generateQuestionsWithAI() async {
    setState(() {
      _isLoadingQuestions = true;
    });

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
    أنشئ 10 أسئلة مختلفة تماما في مجال التكنولوجيا لتحديد ميول الطالب.
    كل سؤال يكون اختيار من متعدد.

    رجع الرد JSON فقط بالشكل ده:
    [
      {"question": "سؤال", "options": ["1","2","3","4"]}
    ]
    ''';

      final response =
      await model.generateContent([Content.text(prompt)]);

      print("RAW RESPONSE:");
      print(response.text);

      String text = response.text ?? "";

      // 🔥 أهم جزء: تنظيف الرد
      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');

      if (start == -1 || end == -1) {
        throw Exception("JSON مش موجود");
      }

      final jsonString = text.substring(start, end + 1);

      final data = json.decode(jsonString);

      print("PARSED LENGTH: ${data.length}");

      setState(() {
        _dynamicQuestions = List<Map<String, dynamic>>.from(data);
        _currentQuestionIndex = 0;
        _userAnswers.clear();
        _isLoadingQuestions = false;
      });
    } catch (e) {
      print("ERROR: $e");

      // 🔥 fallback (عشان تتأكد UI شغال)
      setState(() {
        _dynamicQuestions = [
          {
            "question": "هل تحب البرمجة؟",
            "options": ["نعم", "لا", "مش عارف", "شوية"]
          },
          {
            "question": "هل تحب الهكر؟",
            "options": ["جدا", "لا", "ممكن", "مش مهتم"]
          },
        ];
        _isLoadingQuestions = false;
      });
    }
  }

  // ... باقي الدوال (handleAnswer و analyzeWithRealAI) زي ما هي في الكود السابق ...

  Future<void> _analyzeWithRealAI() async {
    setState(() => _isAnalyzing = true);
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt =
          "حلل هذه الإجابات واقترح تخصص تكنولوجي مناسب للطالب: ${_userAnswers.join('\n')}";
      final response = await model.generateContent([Content.text(prompt)]);
      print("AI RESPONSE:");
      print(response.text);
      setState(() {
        _realAiResponse = response.text ?? "التحليل غير متاح.";
        _isAnalyzing = false;
        _showResult = true;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
        _realAiResponse = "خطأ في التحليل.";
      });
    }
  }

  void _handleAnswer(String answerText, String questionText) {
    _userAnswers.add("س: $questionText | ج: $answerText");
    if (_currentQuestionIndex < _dynamicQuestions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _analyzeWithRealAI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("اختبار الميول المتغير"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoadingQuestions
            ? const Center(child: CircularProgressIndicator())
            : _showResult
            ? _buildResult()
            : _isAnalyzing
            ? const Center(
                child: Text(
                  "جاري التحليل...",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final currentQ = _dynamicQuestions[_currentQuestionIndex];
    return Column(
      children: [
        Text(
          "سؤال ${(_currentQuestionIndex + 1)}/10",
          style: const TextStyle(color: Colors.blue),
        ),
        const SizedBox(height: 20),
        Text(
          currentQ["question"],
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ...List.generate(
          currentQ["options"].length,
          (index) => Card(
            color: Colors.white10,
            child: ListTile(
              title: Text(
                currentQ["options"][index],
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => _handleAnswer(
                currentQ["options"][index],
                currentQ["question"],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        _realAiResponse,
        textDirection: TextDirection.rtl,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("خروج"),
      ),
    ],
  );
}
