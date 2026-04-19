import 'package:flutter/material.dart';

import '../../../services/gemini_service.dart';

class AiChatScreen extends StatefulWidget {
  final String? initialMessage;

  const AiChatScreen({super.key, this.initialMessage});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  final Color bgColor = const Color(0xFF0D1B2A);
  final Color blockColor = const Color(0xFF1B263B);
  final Color primaryCyan = const Color(0xFF00E5FF);

  final List<Map<String, dynamic>> _messages = [
    {
      "isUser": false,
      "text": "أهلاً بك يا أحمد! أنا معلمك الذكي 🤖.\nكيف يمكنني مساعدتك في دراستك اليوم؟"
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _messageController.text = widget.initialMessage!;
    }
  }

  Future<void> _sendMessage() async {
    if (_isLoading) return;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"isUser": true, "text": text});
      _isLoading = true;
    });
    _messageController.clear();

    try {
      final prompt = '''
أنت معلم ذكي لمساعدة الطلاب.
أجب باللغة العربية فقط وبشكل مختصر وواضح.

السؤال: $text
''';

      final responseText = await GeminiService.generate(
        prompt,
        maxInputChars: 4000,
      );

      setState(() {
        _messages.add({
          "isUser": false,
          "text": responseText.replaceAll('*', ''),
        });
      });
    } catch (e) {
      debugPrint("Chat error: $e");
      setState(() {
        _messages.add({
          "isUser": false,
          "text": "عذراً، يرجى المحاولة مرة أخرى لاحقاً.",
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: blockColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy, color: primaryCyan),
            const SizedBox(width: 10),
            const Text(
              "AI Tutor",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message['isUser'], message['text']);
              },
            ),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: primaryCyan, strokeWidth: 2)
                  ),
                  const SizedBox(width: 10),
                  const Text("الذكاء الاصطناعي يكتب...", style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),

          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: primaryCyan.withOpacity(0.2),
              child: Icon(Icons.smart_toy, color: primaryCyan, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? primaryCyan : blockColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: isUser ? bgColor : Colors.white,
                        fontSize: 20,
                        height: 1.4,
                      ),
                    ),
                    if (!isUser) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.bookmark_add_outlined,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: blockColor,
              child: const Icon(Icons.person, color: Colors.white70, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: blockColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "اسأل معلمك الذكي هنا...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _isLoading ? null : _sendMessage,
              child: CircleAvatar(
                backgroundColor: primaryCyan,
                radius: 24,
                child: Icon(Icons.send_rounded, color: bgColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}