import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provadelaco/src/app_widget.dart';
import 'package:provadelaco/src/providers_setup.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     name: 'provasdelaco',
  //     options: FirebaseOptions(
  //       apiKey: "AIzaSyDZ6lea3HfYNHHk56a6XjfyklgXNmKi1EU",
  //       appId: '1:558343760209:web:40cdf70d0e292a66800b70',
  //       messagingSenderId: "558343760209",
  //       projectId: "provasdelaco",
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  HttpOverrides.global = MyHttpOverrides();

  final app = MultiProvider(
    providers: providers,
    child: const AppWidget(),
  );

  runApp(app);
}
