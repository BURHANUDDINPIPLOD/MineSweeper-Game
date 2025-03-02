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
  var squareStatus = [];

  final List<int> bombLocation = [3, 53, 68, 61, 10];
  bool bombsRevealed = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberofSquares; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  void restartGame() {
    setState(() {
      for (int i = 0; i < numberofSquares; i++) {
        squareStatus[i][1] = false;
      }
      bombsRevealed = false;
    });
  }

  void revealBoxNumbers(int index) {
    // Ensure the index is within bounds
    if (index < 0 || index >= numberofSquares) return;

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Center(
            child: Text("You Lost !", style: TextStyle(color: Colors.white)),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: Icon(Icons.refresh),
            ),
          ],
        );
      },
    );
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Center(
            child: Text("You Win !", style: TextStyle(color: Colors.white)),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: Icon(Icons.refresh),
            ),
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
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          SizedBox(
            height: 150,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocation.length.toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    Text("B O M B"),
                  ],
                ),
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    color: Colors.grey[700],
                    child: Icon(Icons.refresh, color: Colors.white, size: 40),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("0", style: TextStyle(fontSize: 40)),
                    Text("T I M E"),
                  ],
                ),
              ],
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
                  return MyBomb(
                    revealed: bombsRevealed,
                    function: () {
                      setState(() {
                        bombsRevealed = true;
                      });
                      playerLost();
                    },
                  );
                } else {
                  return MyNumberbox(
                    child: squareStatus[index][0],
                    revealed: squareStatus[index][1],
                    function: () {
                      revealBoxNumbers(index);
                      checkWinner();
                    },
                  );
                }
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text("C R E A T E D  B Y  B U R H A N"),
          ),
        ],
      ),
    );
  }
}
