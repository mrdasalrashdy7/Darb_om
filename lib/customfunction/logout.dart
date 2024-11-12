import 'package:darb/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

logout() async {
  await FirebaseAuth.instance.signOut();
  prefs!.clear();
}
