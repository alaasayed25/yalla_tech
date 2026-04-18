class RoadmapStep {
  final String title;       // عنوان الخطوة
  final String description; // وصف الخطوة اللي الـ AI هيكتبه
  final bool isCompleted;   // هل الطالب خلصها؟
  final bool isLocked;      // هل مقفولة؟

  RoadmapStep({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isLocked = true,
  });
}