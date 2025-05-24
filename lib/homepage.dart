import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/bomb.dart';
import 'package:myapp/numberbox.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int numberofSquares = 9 * 9;
  int numberInEachRow = 9;
  var squareStatus = []; // Will be list of [int, bool, bool]
  int numberOfFlagsPlaced = 0;

  void toggleFlag(int index) {
    if (squareStatus[index][1]) { // If already revealed, do nothing
      return;
    }
    setState(() {
      if (squareStatus[index][2]) { // If currently flagged
        squareStatus[index][2] = false; // Unflag
        numberOfFlagsPlaced--;
      } else { // If not flagged
        squareStatus[index][2] = true; // Flag
        numberOfFlagsPlaced++;
      }
    });
    checkWinner(); // Check if player won after flagging/unflagging
  }

  final List<int> bombLocation = [3, 53, 68, 61, 10];
  bool bombsRevealed = false;
  int secondsPassed = 0;
  late Timer gameTimer;
  bool isTimerRunning = false;

  void startTimer() {
    if (!isTimerRunning && !bombsRevealed && !playerWon()) { // playerWon() needs to be defined or logic adjusted
      isTimerRunning = true;
      gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          secondsPassed++;
        });
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      gameTimer.cancel();
      isTimerRunning = false;
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      secondsPassed = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberofSquares; i++) {
      squareStatus.add([0, false, false]); // [numberOfBombsAround, isRevealed, isFlagged]
    }
    numberOfFlagsPlaced = 0; // Initialize here
    scanBombs();
  }

  void restartGame() {
    setState(() {
      for (int i = 0; i < numberofSquares; i++) {
        squareStatus[i][1] = false;
        squareStatus[i][2] = false; // Reset isFlagged
      }
      bombsRevealed = false;
      numberOfFlagsPlaced = 0; // Reset flag count
    });
    resetTimer();
  }

  void revealBoxNumbers(int index) {
    // Ensure the index is within bounds
    if (index < 0 || index >= numberofSquares) return;

    // If flagged, do nothing
    if (squareStatus[index][2]) {
      return;
    }

    if (!isTimerRunning && !bombsRevealed) {
      startTimer();
    }

    // If the square contains a number (not zero), reveal it and stop further recursion
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }
    // If the square contains zero, reveal it and recursively reveal neighbors
    else if (squareStatus[index][0] == 0) {
      setState(() {
        squareStatus[index][1] = true;

        // Check and reveal the left neighbor if it's within bounds
        if (index % numberInEachRow != 0) {
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          squareStatus[index - 1][1] = true;
        }

        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        if (index >= numberInEachRow) {
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          squareStatus[index - numberInEachRow][1] = true;
        }

        if (index >= numberInEachRow &&
            // Suggested code may be subject to a license. Learn more: ~LicenseLog:992780297.
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        if (index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          squareStatus[index + 1][1] = true;
        }

        if (index < numberofSquares - numberInEachRow &&
            // Suggested code may be subject to a license. Learn more: ~LicenseLog:1499271600.
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        if (index < numberofSquares - numberInEachRow) {
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          squareStatus[index + numberInEachRow][1] = true;
        }

        if (index < numberofSquares - numberInEachRow &&
            // Suggested code may be subject to a license. Learn more: ~LicenseLog:1499271600.
            index % numberInEachRow != 0) {
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberofSquares; i++) {
      int numberOfBombsAround = 0;
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberofSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberofSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberofSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.sentiment_very_dissatisfied, color: Colors.white, size: 50),
              SizedBox(height: 16),
              Text(
                "YOU LOST!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                "Time: $secondsPassed seconds",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          actions: [
            Center(
              child: MaterialButton(
                color: Colors.blue[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Text("PLAY AGAIN", style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void playerWon() {
    stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.emoji_events, color: Colors.amberAccent, size: 50),
              SizedBox(height: 16),
              Text(
                "YOU WON!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                "Your time: $secondsPassed seconds!",
                style: TextStyle(color: Colors.white, fontSize: 18), // Slightly more prominent
              ),
            ],
          ),
          actions: [
            Center(
              child: MaterialButton(
                color: Colors.blue[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Text("PLAY AGAIN", style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberofSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }
    // Suggested code may be subject to a license. Learn more: ~LicenseLog:3349436529.
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // New background color
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Container( // Wrap Row with Container to set background color
              color: Colors.blue[700], // New top bar color
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (bombLocation.length - numberOfFlagsPlaced).toString(),
                        style: TextStyle(fontSize: 40, color: Colors.white), // White text
                      ),
                      Text("B O M B", style: TextStyle(color: Colors.white)), // White text
                    ],
                  ),
                  GestureDetector(
                    onTap: restartGame,
                    child: Card(
                      color: Colors.blue[500], // New accent color for refresh button
                      child: Icon(Icons.refresh, color: Colors.white, size: 40),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(secondsPassed.toString(), style: TextStyle(fontSize: 40, color: Colors.white)), // White text
                      Text("T I M E", style: TextStyle(color: Colors.white)), // White text
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInEachRow,
              ),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return GestureDetector( // Outer GestureDetector for MyBomb
                    onLongPress: () {
                      toggleFlag(index);
                    },
                    child: MyBomb(
                      revealed: bombsRevealed,
                      isFlagged: squareStatus[index][2], // Pass isFlagged
                      function: () {
                        if (!squareStatus[index][2]) { // If not flagged
                           setState(() {
                            bombsRevealed = true;
                          });
                          playerLost();
                        }
                      },
                    ),
                  );
                } else {
                  return GestureDetector( // Outer GestureDetector for MyNumberbox
                    onLongPress: () {
                      toggleFlag(index);
                    },
                    child: MyNumberbox(
                      child: squareStatus[index][0],
                      revealed: squareStatus[index][1],
                      isFlagged: squareStatus[index][2], // Pass isFlagged
                      function: () {
                        revealBoxNumbers(index);
                        checkWinner();
                      },
                    ),
                  );
                }
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              "C R E A T E D  B Y  B U R H A N",
              style: TextStyle(color: Colors.blueGrey[700]), // New text color
            ),
          ),
        ],
      ),
    );
  }
}
