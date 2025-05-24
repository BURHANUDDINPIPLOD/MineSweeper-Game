import 'package:flutter/material.dart';

class MyBomb extends StatelessWidget {
  bool revealed;
  final function;
  final bool isFlagged; // New parameter

  MyBomb({super.key,  required this.revealed, this.function, required this.isFlagged}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: revealed
              ? BoxDecoration(
                  color: Colors.redAccent, // Warning color for revealed bomb
                )
              : BoxDecoration(
                  // Unrevealed state (consistent with MyNumberbox)
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
          child: revealed
              ? Center( // If revealed (game over), show bomb icon
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.white,
                    size: 20.0,
                  ),
                )
              : isFlagged // If not revealed and is flagged, show flag
                  ? Center(
                      child: Icon(
                        Icons.flag,
                        color: Colors.black, // Or Colors.red for more emphasis
                        size: 20.0,
                      ),
                    )
                  : null, // If not revealed and not flagged, show nothing
        ),
      ),
    );
  }
}
