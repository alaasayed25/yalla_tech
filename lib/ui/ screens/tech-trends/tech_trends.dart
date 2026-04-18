import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TechTrendsScreen extends StatefulWidget {
  const TechTrendsScreen({super.key});

  @override
  State<TechTrendsScreen> createState() => _TechTrendsScreenState();
}

class _TechTrendsScreenState extends State<TechTrendsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTechNews(); // أول ما الصفحة تفتح، انده على الأخبار
  }

  // الدالة اللي بتجيب الأخبار من الـ API بتاع المبرمجين
  Future<void> fetchTechNews() async {
    // رابط Dev.to بيجيب مقالات وأخبار عن البرمجة والتقنية (ومش محتاج أي مفاتيح!)
    const String url = 'https://dev.to/api/articles?tag=programming&per_page=20';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // هنا الداتا بترجع كـ List على طول مش جوه كلمة articles
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          // بنفلتر الأخبار عشان نجيب اللي ليها صور بس (cover_image أو social_image)
          articles = data.where((article) =>
          article['cover_image'] != null || article['social_image'] != null
          ).toList();
          isLoading = false;
        });
      } else {
        // لو حصل مشكلة في السيرفر
        setState(() => isLoading = false);
      }
    } catch (e) {
      // لو مفيش نت
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Tech Trends 🚀", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent), // علامة التحميل
      )
          : articles.isEmpty
          ? const Center(
        child: Text("مفيش أخبار دلوقتي أو تأكد من الإنترنت", style: TextStyle(color: Colors.white)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildTrendCard(
              article['title'] ?? 'بدون عنوان',
              article['description'] ?? 'لا يوجد تفاصيل إضافية لهذا الخبر.',
              // هنا عدلنا اسم الصورة عشان يتناسب مع Dev.to
              article['cover_image'] ?? article['social_image'] ?? '',
              Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendCard(String title, String desc, String imageUrl, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey[900],
                child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 50),
              ),
            )
                : Container(
              height: 180,
              color: Colors.grey[900],
              child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // عشان لو العنوان طويل يحط نقط
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}