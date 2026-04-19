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
