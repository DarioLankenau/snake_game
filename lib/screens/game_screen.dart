import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import '../game/snake_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  SnakeGameComponent? game;
  bool _gameInitialized = false;
  final FocusNode _focusNode = FocusNode();
  bool _isNavigating = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gameInitialized) {
      final level = ModalRoute.of(context)?.settings.arguments as int? ?? 1;
      game = SnakeGameComponent()..level = level;
      _gameInitialized = true;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
      
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _checkGameState();
        }
      });
    }
  }
  
  void _checkGameState() {
    if (game == null || !mounted) return;
    
    if (game!.gameOver || game!.gameWon) {
      if (!_isNavigating) {
        _isNavigating = true;
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && game != null) {
            Navigator.pushNamed(
              context,
              '/result',
              arguments: {
                'level': game!.level,
                'score': game!.score,
                'won': game!.gameWon,
              },
            );
          }
        });
      }
      return;
    }
    
    if (!_isNavigating) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && !_isNavigating && game != null) {
          _checkGameState();
        }
      });
    }
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }
    
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowUp): _DirectionIntent.up,
        SingleActivator(LogicalKeyboardKey.arrowDown): _DirectionIntent.down,
        SingleActivator(LogicalKeyboardKey.arrowLeft): _DirectionIntent.left,
        SingleActivator(LogicalKeyboardKey.arrowRight): _DirectionIntent.right,
      },
      child: Actions(
        actions: {
          _DirectionIntent: _DirectionAction(game: game),
        },
        child: Focus(
          autofocus: true,
          focusNode: _focusNode,
          child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
            final isTablet = constraints.maxWidth > 600;
            
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.green),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Level ${game!.level}',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Focus(
                        autofocus: false,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                        final dx = details.delta.dx;
                        final dy = details.delta.dy;
                        
                        if (dx.abs() > dy.abs()) {
                          if (dx > 0) {
                            game?.changeDirection(Direction.right);
                          } else {
                            game?.changeDirection(Direction.left);
                          }
                        } else {
                          if (dy > 0) {
                            game?.changeDirection(Direction.down);
                          } else {
                            game?.changeDirection(Direction.up);
                          }
                        }
                      },
                          child: GameWidget<SnakeGameComponent>.controlled(
                            gameFactory: () => game!,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => game!.changeDirection(Direction.up),
                            icon: const Icon(Icons.arrow_upward),
                            label: const Text('UP'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                              backgroundColor: Colors.green.withOpacity(0.3),
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => game!.changeDirection(Direction.left),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('LEFT'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                                  backgroundColor: Colors.green.withOpacity(0.3),
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => game!.changeDirection(Direction.right),
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('RIGHT'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                                  backgroundColor: Colors.green.withOpacity(0.3),
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => game!.changeDirection(Direction.down),
                            icon: const Icon(Icons.arrow_downward),
                            label: const Text('DOWN'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                              backgroundColor: Colors.green.withOpacity(0.3),
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),
            );
          },
        ),
          ),
        ),
      ),
    );
  }
}

class _DirectionIntent extends Intent {
  final Direction direction;
  const _DirectionIntent(this.direction);
  
  static const up = _DirectionIntent(Direction.up);
  static const down = _DirectionIntent(Direction.down);
  static const left = _DirectionIntent(Direction.left);
  static const right = _DirectionIntent(Direction.right);
}

class _DirectionAction extends Action<_DirectionIntent> {
  final SnakeGameComponent? game;
  _DirectionAction({required this.game});
  
  @override
  Object? invoke(_DirectionIntent intent) {
    if (game != null && !game!.gameOver && !game!.gameWon) {
      game!.changeDirection(intent.direction);
    }
    return null;
  }
}

