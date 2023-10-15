import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({
    super.key,
    required String info,
  }) : _info = info;

  final String _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_info),
      ),
    );
  }
}
