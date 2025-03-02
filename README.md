# Minesweeper Game

A classic Minesweeper game implemented in Flutter. The game challenges players to uncover squares on a grid while avoiding hidden bombs. Use logic to determine safe squares and uncover all non-bomb squares to win!

## Features

- **Dynamic Grid**: A 9x9 grid with squares that can either be safe or contain a bomb.
- **Bomb Detection**: Logic to calculate the number of bombs surrounding each square.
- **Recursive Reveal**: Automatically reveals neighboring squares with zero bombs.
- **Interactive Gameplay**: Tap squares to reveal them; avoid the bombs!
- **Customizable Bomb Locations**: Predefined bomb locations for consistent testing.
- **Restart Option**: Easily restart the game for a new challenge.

## How to Play

1. **Objective**: Uncover all squares that do not contain a bomb.
2. **Revealing Squares**:
   - Tap on a square to reveal it.
   - If the square is safe, it will display the number of bombs in adjacent squares.
   - If the square has no adjacent bombs, neighboring squares will be automatically revealed.
   - If you tap on a bomb, the game ends.
3. **Winning**: Successfully reveal all safe squares without tapping on a bomb.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/minesweeper-game.git
   ```
2. Navigate to the project directory:
   ```bash
   cd minesweeper-game
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## File Structure

- `lib/`
  - `homepage.dart`: Contains the main game logic and UI.
  - `bomb.dart`: Widget for displaying bombs.
  - `numberbox.dart`: Widget for displaying safe squares with numbers.

## Key Code Highlights

### Bomb Detection Logic
Counts the number of bombs surrounding each square to update the grid state.
```dart
void scanBombs() {
  for (int i = 0; i < numberofSquares; i++) {
    int numberOfBombsAround = 0;
    // Add checks for each neighboring square
    if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
      numberOfBombsAround++;
    }
    // More checks for other neighbors...
    setState(() {
      squareStatus[i][0] = numberOfBombsAround;
    });
  }
}
```

### Recursive Reveal Logic
Automatically reveals neighboring squares if the current square has no adjacent bombs.
```dart
void revealBoxNumbers(int index) {
  if (index < 0 || index >= numberofSquares) return;
  if (squareStatus[index][1] || bombLocation.contains(index)) return;

  setState(() {
    squareStatus[index][1] = true;
  });

  if (squareStatus[index][0] == 0) {
    if (index % numberInEachRow != 0) revealBoxNumbers(index - 1);
    if (index % numberInEachRow != numberInEachRow - 1) revealBoxNumbers(index + 1);
    if (index >= numberInEachRow) revealBoxNumbers(index - numberInEachRow);
    if (index < numberofSquares - numberInEachRow) revealBoxNumbers(index + numberInEachRow);
  }
}
```

## Screenshots

![Screen Shot 2025-03-02 at 12 17 40 PM](https://github.com/user-attachments/assets/43e7bfcc-f354-43b9-b41e-934c43573e75)

## Working 


https://github.com/user-attachments/assets/2f41f258-c3c4-47dd-a680-c17060120de9




## Future Improvements

- **Dynamic Bomb Placement**: Allow random bomb placement at the start of the game.
- **Difficulty Levels**: Add options for different grid sizes and bomb densities.
- **Timer**: Include a timer to track how long the player takes to win.
- **Leaderboard**: Save high scores and display a leaderboard.
- **Animations**: Add animations for square reveals and game-over events.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

Enjoy playing Minesweeper! 🚩💣
