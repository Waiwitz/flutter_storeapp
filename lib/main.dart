import 'package:flutter/material.dart';
import 'package:storeapp/login_page.dart';
import 'package:storeapp/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'myapp',
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage()
        },
        // theme: ThemeData(
        //     appBarTheme: const AppBarTheme(backgroundColor: Colors.orange)),
        // home: App();
    );
  }
}