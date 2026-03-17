// // import '../services/api_service.dart';
// //
// // class AuthService {
// //
// //   /// Login
// //   static Future<String?> login({
// //     required String email,
// //     required String password,
// //   }) async {
// //
// //     try {
// //
// //       final response = await ApiService.postData(
// //         endpoint: "login",
// //         body: {
// //           "email": email,
// //           "password": password,
// //         },
// //       );
// //
// //       return response["token"];
// //
// //     } catch (e) {
// //       return null;
// //     }
// //   }
// //
// //   /// Register
// //   static Future<String?> register({
// //     required String email,
// //     required String password,
// //   }) async {
// //
// //     try {
// //
// //       final response = await ApiService.postData(
// //         endpoint: "register",
// //         body: {
// //           "email": email,
// //           "password": password,
// //         },
// //       );
// //
// //       return response["token"];
// //
// //     } catch (e) {
// //       return null;
// //     }
// //   }
// // }




// import '../services/api_service.dart';
// class AuthService {
//   /// Login (Local Mock)
//   static Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       // بنعمل تأخير بسيط عشان نحس بـ Loading التحميل
//       await Future.delayed(const Duration(seconds: 1));
//
//       // أي حد هيكتب إيميل فيه @ وباسورد أكتر من 5 حروف هيدخل
//       if (email.contains('@') && password.length > 5) {
//         print("Login Successful (Local)");
//         return "local_token_success_123";
//       } else {
//         print("Login Failed: Invalid credentials");
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Register (Local Mock)
//   static Future<String?> register({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//
//       // نفس المنطق للتسجيل مؤقتاً
//       if (email.isNotEmpty && password.length > 5) {
//         print("Register Successful (Local)");
//         return "local_token_success_123";
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register Real (Firebase)
  static Future<String?> register({
    required String email,
    required String password,
    required String name, // ضفنا الاسم عشان نحفظه
  }) async {
    try {
      // 1. إنشاء الحساب في الـ Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. حفظ بيانات إضافية (الاسم والمسار) في الـ Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
        'path': 'Not determined yet', // المسار التقني لسه محددناهوش
      });

      return userCredential.user!.uid; // بنرجع الـ ID بتاع اليوزر
    } catch (e) {
      print("Error in Register: $e");
      return null;
    }
  }

  /// Login Real (Firebase)
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      print("Error in Login: $e");
      return null;
    }
  }
}
