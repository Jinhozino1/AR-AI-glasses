import 'package:flutter/material.dart';
import 'package:untitled/AI/camera_AI.dart';
import 'package:untitled/models/model_auth.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         // Text('Profile'),
          TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text('로그아웃 되었습니다.')),
                    );
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Logout'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/MainAi');
              },
              child: Text("AI 추천"),
          ),
        ],
      ),
    );
  }
}