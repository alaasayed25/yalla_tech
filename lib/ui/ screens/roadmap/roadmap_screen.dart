import 'package:flutter/material.dart';
import '../../../data/models/roadmap_model/roadmap_step_model.dart';

class CareerRoadmapScreen extends StatelessWidget {
  // ضفنا المتغيرات دي عشان الشاشة تستقبلها من الـ AI بعدين
  final String careerPathName;
  final List<RoadmapStep> steps;

  const CareerRoadmapScreen({
    super.key,
    required this.careerPathName,
    required this.steps,
  });

  final Color backgroundColor = const Color(0xFF0D1B2A);
  final Color cardColor = const Color(0xFF1B263B);
  final Color primaryCyan = const Color(0xFF00E5FF);
  final Color textColor = const Color(0xFFD4E1EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Learning Roadmap",
          style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPathHeader(),
            const SizedBox(height: 30),

            // هنا السحر! فلاتر هيلف على اللستة ويرسم الكروت لوحده
            ...steps.asMap().entries.map((entry) {
              int index = entry.key;
              RoadmapStep step = entry.value;
              bool isLast = index == steps.length - 1;

              // بنحدد حالة الخطوة (خلصت، شغالة، مقفولة)
              StepStatus status;
              if (step.isCompleted) {
                status = StepStatus.completed;
              } else if (!step.isLocked) {
                status = StepStatus.active;
              } else {
                status = StepStatus.locked;
              }

              return _buildTimelineStep(
                title: step.title,
                subtitle: step.description,
                status: status,
                icon: Icons.lightbulb_outline, // أيكونة مؤقتة للكل
                isLast: isLast,
              );
            }).toList(), // بنقفل اللوب
          ],
        ),
      ),
    );
  }

  Widget _buildPathHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryCyan.withOpacity(0.2), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryCyan.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_motion, color: primaryCyan, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  careerPathName, // خلينا الاسم ديناميك
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Your personalized AI path",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required StepStatus status,
    required IconData icon,
    bool isLast = false,
  }) {
    Color statusColor = status == StepStatus.completed
        ? primaryCyan
        : (status == StepStatus.active ? Colors.white : Colors.white24);

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: status == StepStatus.active ? primaryCyan : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Icon(
                  status == StepStatus.completed ? Icons.check : icon,
                  size: 16,
                  color: status == StepStatus.active ? Colors.black : statusColor,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: status == StepStatus.completed ? primaryCyan : Colors.white12,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: status == StepStatus.active ? primaryCyan.withOpacity(0.5) : Colors.white12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: status == StepStatus.locked ? Colors.white38 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: status == StepStatus.locked ? Colors.white24 : Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum StepStatus { completed, active, locked }