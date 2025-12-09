import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
          final isTablet = constraints.maxWidth > 600;
          
          return Container(
            color: Colors.black,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videogame_asset,
                        size: isTablet ? 120 : 80,
                        color: Colors.green,
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      Text(
                        'SNAKE',
                        style: TextStyle(
                          fontSize: isTablet ? 64 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.green.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 48 : 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/levels');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 48 : 32,
                            vertical: isTablet ? 20 : 16,
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Start Game'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Swipe or tap to control the snake',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

