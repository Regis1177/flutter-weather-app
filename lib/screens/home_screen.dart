import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather in Polish Cities'),
      ),
      body: const Center(
        child: Text('Weather data will be displayed here.'),
      ),
    );
  }
}
