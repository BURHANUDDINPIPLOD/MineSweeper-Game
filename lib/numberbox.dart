import 'package:flutter/material.dart';

class MyNumberbox extends StatelessWidget {
  final child;
  bool revealed;
  final function;
  final bool isFlagged; // New parameter

  MyNumberbox({super.key, this.child, required this.revealed, this.function, required this.isFlagged}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: revealed
              ? BoxDecoration(
                  // Revealed state
                  color: child == 0 ? Colors.grey[200] : Colors.grey[300],
                )
              : BoxDecoration(
                  // Unrevealed state (base style for both flagged and unflagged)
                  color: Colors.grey[400],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      offset: Offset(-2.0, -2.0),
                      blurRadius: 2.0,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: Colors.grey[500]!,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
          child: Center(
            child: revealed
                ? Text( // If revealed, show number or nothing
                    (child == 0 ? '' : child.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: child == 1
                          ? Colors.blue
                          : child == 2
                              ? Colors.green
                              : Colors.red,
                    ),
                  )
                : isFlagged // If not revealed and is flagged, show flag
                    ? Icon(Icons.flag, color: Colors.black, size: 20.0)
                    : Text(""), // If not revealed and not flagged, show nothing
          ),
        ),
      ),
    );
  }
}
// This part of the search block was for the text style, which is now handled above.
// The previous structure had the text style separate from the conditional rendering
// of the flag or number. The new structure integrates this logic.
