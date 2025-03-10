import 'package:flutter/material.dart';

class MyNumberbox extends StatelessWidget {
  final child;
  bool revealed;
  final function;

  MyNumberbox({super.key, this.child, required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(child: Text(
            revealed ? (child == 0 ? '' : child.toString()) : "",
            style: TextStyle(
              color: child == 1 ? Colors.blue : (child == 2 ? Colors.green :Colors.red),
              fontWeight: FontWeight.bold,
              ),
            ),
            ),
        ),
      ),
    );
  }
}
