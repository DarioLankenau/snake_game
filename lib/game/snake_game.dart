import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class SnakeGameComponent extends FlameGame {
  SnakeGameComponent();
  
  late int level;
  late double cellSize;
  late int gridWidth;
  late int gridHeight;
  
  List<Vector2> snake = [];
  Vector2? food;
  Direction currentDirection = Direction.right;
  Direction nextDirection = Direction.right;
  bool gameOver = false;
  bool gameWon = false;
  int score = 0;
  int targetScore = 10;
  double gameSpeed = 0.15;
  
  TimerComponent? moveTimer;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    switch (level) {
      case 1:
        targetScore = 10;
        gameSpeed = 0.2;
        break;
      case 2:
        targetScore = 15;
        gameSpeed = 0.15;
        break;
      case 3:
        targetScore = 20;
        gameSpeed = 0.12;
        break;
      default:
        targetScore = 10;
        gameSpeed = 0.2;
    }
    
    const fixedWidth = 400.0;
    const fixedHeight = 600.0;
    
    gridWidth = 20;
    gridHeight = 30;
    cellSize = min(fixedWidth / gridWidth, fixedHeight / gridHeight);
    
    final startX = gridWidth ~/ 2;
    final startY = gridHeight ~/ 2;
    snake = [
      Vector2(startX.toDouble(), startY.toDouble()),
      Vector2((startX - 1).toDouble(), startY.toDouble()),
      Vector2((startX - 2).toDouble(), startY.toDouble()),
    ];
    
    spawnFood();
    
    moveTimer = TimerComponent(
      period: gameSpeed,
      repeat: true,
      onTick: () {
        if (!gameOver && !gameWon && moveTimer != null) {
          moveSnake();
        }
      },
    );
    add(moveTimer!);
  }
  
  void changeDirection(Direction newDirection) {
    if ((currentDirection == Direction.up && newDirection == Direction.down) ||
        (currentDirection == Direction.down && newDirection == Direction.up) ||
        (currentDirection == Direction.left && newDirection == Direction.right) ||
        (currentDirection == Direction.right && newDirection == Direction.left)) {
      return;
    }
    nextDirection = newDirection;
  }
  
  void moveSnake() {
    if (gameOver || gameWon || moveTimer == null) {
      _stopTimer();
      return;
    }
    
    currentDirection = nextDirection;
    
    Vector2 head = snake[0];
    Vector2 newHead = Vector2(head.x, head.y);
    
    switch (currentDirection) {
      case Direction.up:
        newHead.y -= 1;
        break;
      case Direction.down:
        newHead.y += 1;
        break;
      case Direction.left:
        newHead.x -= 1;
        break;
      case Direction.right:
        newHead.x += 1;
        break;
    }
    
    if (newHead.x < 0 || newHead.x >= gridWidth || newHead.y < 0 || newHead.y >= gridHeight) {
      _stopTimer();
      gameOver = true;
      return;
    }
    
    if (snake.contains(newHead)) {
      _stopTimer();
      gameOver = true;
      return;
    }
    
    snake.insert(0, newHead);
    
    if (food != null && newHead.x == food!.x && newHead.y == food!.y) {
      score++;
      spawnFood();
      if (score >= targetScore) {
        _stopTimer();
        gameWon = true;
      }
    } else {
      snake.removeLast();
    }
  }
  
  void _stopTimer() {
    if (moveTimer != null) {
      try {
        moveTimer!.timer.stop();
        if (moveTimer!.isMounted) {
          moveTimer!.removeFromParent();
        }
      } catch (e) {
      }
      moveTimer = null;
    }
  }
  
  void spawnFood() {
    Random random = Random();
    Vector2 newFood;
    do {
      newFood = Vector2(
        random.nextInt(gridWidth).toDouble(),
        random.nextInt(gridHeight).toDouble(),
      );
    } while (snake.contains(newFood));
    food = newFood;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.black,
    );
    
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    
    for (int i = 0; i <= gridWidth; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, gridHeight * cellSize),
        paint,
      );
    }
    
    for (int i = 0; i <= gridHeight; i++) {
      final y = i * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(gridWidth * cellSize, y),
        paint,
      );
    }
    
    if (food != null) {
      final foodPaint = Paint()..color = Colors.red;
      canvas.drawCircle(
        Offset(food!.x * cellSize + cellSize / 2, food!.y * cellSize + cellSize / 2),
        cellSize / 2 - 2,
        foodPaint,
      );
    }
    
    final snakePaint = Paint()..color = Colors.green;
    for (int i = 0; i < snake.length; i++) {
      final segment = snake[i];
      final rect = Rect.fromLTWH(
        segment.x * cellSize + 1,
        segment.y * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );
      canvas.drawRect(rect, snakePaint);
    }
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: $score / $targetScore',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));
    
    if (gameOver) {
      final gameOverPainter = TextPainter(
        text: const TextSpan(
          text: 'GAME OVER',
          style: TextStyle(
            color: Colors.red,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      gameOverPainter.layout();
      gameOverPainter.paint(
        canvas,
        Offset((size.x - gameOverPainter.width) / 2, size.y / 2 - 40),
      );
    } else if (gameWon) {
      final winPainter = TextPainter(
        text: const TextSpan(
          text: 'LEVEL COMPLETE!',
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      winPainter.layout();
      winPainter.paint(
        canvas,
        Offset((size.x - winPainter.width) / 2, size.y / 2 - 40),
      );
    }
  }
}

