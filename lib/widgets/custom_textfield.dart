// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//
//   final String hint;
//   final bool obscure;
//   final TextEditingController? controller;
//
//   const CustomTextField({
//     super.key,
//     required this.hint,
//     this.obscure = false,
//     this.controller, required TextInputType keyboardType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return TextField(
//
//       controller: controller,
//       obscureText: obscure,
//
//       decoration: InputDecoration(
//
//         hintText: hint,
//
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  // 1. خليه اختياري (Optional) عشان مش كل الحقول محتاجة نوع كيبورد معين
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.keyboardType, // شلنا كلمة required عشان ميتعبكش في الباسورد مثلاً
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      // 2. أهم خطوة: اربط المتغير بالخاصية اللي جوه الـ TextField
      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}