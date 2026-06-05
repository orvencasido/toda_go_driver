import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;

  const PhoneFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}