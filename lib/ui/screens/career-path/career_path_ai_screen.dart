import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';

class CareerPathAIScreen extends StatefulWidget {
  const CareerPathAIScreen({super.key});

  @override
  State<CareerPathAIScreen> createState() => _CareerPathAIScreenState();
}

class _CareerPathAIScreenState extends State<CareerPathAIScreen> {
  int _currentQuestionIndex = 0;
  bool _isAnalyzing = false;
  bool _showResult = false;

  // الـ API Key بتاعك
  final String apiKey = 'AIzaSyD_MU2A8_-kU0YI7f4s_YB2RjbzTUWZktQ';

  final List<String> _userAnswers = [];
  String _realAiResponse = "";

  final List<Map<String, dynamic>> _questionBank = [
    {
      "question": "لما بتقابل مشكلة معقدة في حياتك أو دراستك، بتفضل تحلها إزاي؟ 🤔",
      "options": [
        "أمسك ورقة وقلم وأحلل الموضوع بخطوات منطقية.",
        "أدور على أصل المشكلة وأسبابها العلمية أو النفسية.",
        "أدور على أداة أو تطبيق أو حل تكنولوجي ينجزني.",
        "أفكر بره الصندوق وأتخيل حلول إبداعية ومختلفة."
      ]
    },
    {
      "question": "إيه أكتر حاجة بتلفت انتباهك لما بتنزل تشتري جهاز جديد (زي الموبايل أو اللاب توب)؟ 📱",
      "options": [
        "إمكانيات السوفت وير ونظام التشغيل والبرامج.",
        "شكل الجهاز، تصميمه، وألوانه.",
        "قوة الهاردوير، البروسيسور، وإزاي القطع متركبة من جوه.",
        "سعره، الضمان، وإزاي أستفيد منه في شغلي وتنظيم وقتي."
      ]
    },
    {
      "question": "لو اشتركت في مشروع تخرج أو مسابقة مع زمايلك، تحب يكون دورك إيه؟ 🏆",
      "options": [
        "أكون الليدر (القائد) اللي بيوزع المهام وينظم الشغل.",
        "أصمم شكل البرزنتيشن، اللوجو، والواجهة بتاعة المشروع.",
        "أبني الهيكل الأساسي أو أبرمج الجزء العملي بنفسي.",
        "أعمل البحث العلمي وأجمع المعلومات والتجارب المطلوبة."
      ]
    },
    {
      "question": "إيه أكتر نوع من المعلومات بتحس إنك بتستمتع وإنت بتقراه أو بتذاكره؟ 📚",
      "options": [
        "معلومات عن جسم الإنسان، الطبيعة، أو الكيمياء.",
        "المعادلات، الأرقام، وقوانين الفيزياء.",
        "التكنولوجيا الحديثة، الذكاء الاصطناعي، والأكواد.",
        "التاريخ، اللغات، أو قصص نجاح الشركات الكبيرة."
      ]
    },
    {
      "question": "في وقت فراغك، بتفضل تقضي وقتك في إيه؟ ⏳",
      "options": [
        "أتابع أخبار البيزنس، البورصة، والشركات الناشئة.",
        "أتعلم مهارة جديدة على الكمبيوتر أو ألعب ألعاب استراتيجية.",
        "أفكك أجهزة قديمة وأحاول أصلحها أو أركب حاجات في بعض.",
        "أتفرج على أفلام وثائقية عن الطبيعة أو أرسم وأصمم."
      ]
    }
  ];

  late List<Map<String, dynamic>> _sessionQuestions;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    _questionBank.shuffle(Random());
    _sessionQuestions = _questionBank.take(5).toList();
    for (var q in _sessionQuestions) {
      (q["options"] as List).shuffle(Random());
    }
  }

  void _handleAnswer(String answerText, String questionText) {
    _userAnswers.add("السؤال: $questionText \nالإجابة: $answerText\n");
    if (_currentQuestionIndex < _sessionQuestions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _analyzeWithRealAI();
    }
  }

  Future<void> _analyzeWithRealAI() async {
    setState(() => _isAnalyzing = true);

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );
      String prompt = '''
      أنت مستشار توجيه مهني. بناءً على هذه الإجابات، حلل شخصية الطالب واقترح له كليتين مناسبتين مع السبب:
      ${_userAnswers.join('\n')}
      الرد يجب أن يكون باللغة العربية، منظم، ومختصر.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _realAiResponse = response.text ?? "عذراً، لم أتمكن من الحصول على تحليل.";
        _isAnalyzing = false;
        _showResult = true;
      });
    } catch (e) {
      // طباعة الخطأ التقني في الـ Console لمعرفته
      print("🚨🚨🚨 Gemini Error: $e");

      setState(() {
        _isAnalyzing = false;
        _showResult = true;

        // تحليل نوع الخطأ وعرض رسالة مناسبة للمستخدم
        if (e.toString().contains('location')) {
          _realAiResponse = "خطأ: الخدمة غير مدعومة في موقعك. تأكد من تشغيل WARP VPN وتغيير Private DNS لـ dns.google داخل إعدادات المحاكي.";
        } else if (e.toString().contains('API_KEY_INVALID')) {
          _realAiResponse = "خطأ: مفتاح الـ API غير صحيح. يرجى التأكد من نسخه بشكل سليم من Google AI Studio.";
        } else if (e.toString().contains('deadline-exceeded')) {
          _realAiResponse = "خطأ: استغرق الطلب وقتاً طويلاً (Timeout). ضعف في الاتصال بالإنترنت.";
        } else {
          _realAiResponse = "حدث خطأ تقني: ${e.toString().split(':').last}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("المستشار المهني (AI)", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _showResult
            ? _buildResultCard()
            : _isAnalyzing
            ? _buildAnalyzingState()
            : _buildQuestionState(),
      ),
    );
  }

  Widget _buildQuestionState() {
    final currentQ = _sessionQuestions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _sessionQuestions.length,
          backgroundColor: Colors.white12,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 25),
        Text(currentQ["question"], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: currentQ["options"].length,
            itemBuilder: (context, index) {
              final optionText = currentQ["options"][index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(optionText, style: const TextStyle(color: Colors.white)),
                  onTap: () => _handleAnswer(optionText, currentQ["question"]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blueAccent),
          SizedBox(height: 20),
          Text("الذكاء الاصطناعي يحلل إجاباتك حالياً...", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 50),
              const SizedBox(height: 20),
              Text(_realAiResponse, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("رجوع")),
            ],
          ),
        ),
      ),
    );
  }
}