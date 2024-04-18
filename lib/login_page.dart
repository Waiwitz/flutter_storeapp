import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginService {
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    var urlLogin = Uri.parse(dotenv.env['LOGIN']!);

    var body = {"username": username, "password": password};

    try {
      final res = await http.post(
        urlLogin,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final resJson = jsonDecode(res.body);
        final token = resJson['token'];
        await storage.write(key: 'jwt', value: token);
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Login failed. Status code: ${res.statusCode}'
        };
      }
    } catch (err) {
      return {'success': false, 'message': 'Error during login: $err'};
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void login() {
    setState(() {
      _isLoading = true; // Set loading flag to true
    });
    LoginService.login(_usernameController.text, _passwordController.text)
        .then((result) {
      setState(() {
        _isLoading = false;
      });
      if (result['success'] == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog(result['message']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      margin: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 15.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
              onPressed: _isLoading ? null : login, child: const Text('Login')),
          if (_isLoading) const CircularProgressIndicator()
        ],
      ),
    )));
  }
}
