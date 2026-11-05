import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  String _result = 'جاري الاتصال بالسيرفر...';

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  Future<void> _loadMe() async {
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      setState(() {
        _result = 'Code: ${response.statusCode}\n\n${utf8.decode(response.bodyBytes)}';
      });
    } catch (e) {
      setState(() => _result = 'خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(_result, textAlign: TextAlign.center)),
      ),
    );
  }
}