import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '쿵쓰가 되어 볼까요?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '가입하면 최대 7,000원\n즉시 할인 쿠폰 증정',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // login
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
